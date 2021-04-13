//  
//  ArduinoSyncManager.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 03/02/21.
//  Copyright © 2021 Arduino. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

import RxSwift

import googlemac_iPhone_Shared_SSOAuth_SSOAuth
import GTMSessionFetcher
import GoogleAPIClientForREST

enum ArduinoSyncManagerError: Error {
  case exportError
  case experimentNotDirty
  case missingSyncFolder
  case missingFileID
  case missingLastSyncedVersion
  case missingExperimentOnDrive
  case experimentAlreadyOnDrive
  case missingExperimentID
  case conflict(_ experiment: SyncExperiment, _ file: GTLRDrive_File)
  case importingDocumentWhileRecording
  case filesystemError
  case importError
}

final class ArduinoSyncManager: DriveSyncManager {
  let metadataManager: MetadataManager
  let sensorDataManager: SensorDataManager
  let experimentDataDeleter: ExperimentDataDeleter
  let driveFetcher: DriveFetcher
  let folderID: String
  
  weak var delegate: DriveSyncManagerDelegate?
  
  private let operationQueue = GSJOperationQueue()
  
  private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
 
  private var syncSubscription: Disposable?
  
  private lazy var isStarted = BehaviorSubject<Bool>(value: true)
  private lazy var isSuspended = BehaviorSubject<Bool>(value: false)
  private lazy var syncRefresh = PublishSubject<Void>()
  
  private lazy var disposeBag = DisposeBag()
  
  init(metadataManager: MetadataManager,
       sensorDataManager: SensorDataManager,
       experimentDataDeleter: ExperimentDataDeleter,
       driveFetcher: DriveFetcher,
       folderID: String) {
    
    self.metadataManager = metadataManager
    self.sensorDataManager = sensorDataManager
    self.experimentDataDeleter = experimentDataDeleter
    self.driveFetcher = driveFetcher
    self.folderID = folderID
    
    Observable.combineLatest(isStarted, isSuspended)
      .map { $0 && !$1 }
      .distinctUntilChanged()
      .subscribe(on: MainScheduler.instance)
      .subscribe(onNext: { [unowned self] in
        $0 ? startSyncEngine() : stopSyncEngine()
      })
      .disposed(by: disposeBag)
  }
  
  func syncExperimentLibrary() {
    syncRefresh.onNext(())
  }
  
  func syncExperiment(withID experimentID: String, condition: DriveExperimentSyncCondition) {
    
  }
  
  func syncTrialSensorData(atURL url: URL, experimentID: String) {
    
  }
  
  func deleteExperiment(withID experimentID: String) {
    metadataManager.experimentLibrary.setExperimentDeleted(true, experimentID: experimentID)
    metadataManager.saveExperimentLibrary()
    
    syncRefresh.onNext(())
  }
  
  func experimentLibraryExists(completion: @escaping (Bool?) -> Void) {
    completion(true)
  }
  
  func deleteImageAssets(atURLs urls: [URL], experimentID: String) {
    
  }
  
  func deleteSensorDataAsset(atURL url: URL, experimentID: String) {
    
  }
  
  func resolveConflictOfExperiment(withID experimentID: String, overwritingRemote: Bool) {
    if overwritingRemote {
      let metadataManager = self.metadataManager
      
      guard let experiment = metadataManager.experimentLibrary.syncExperiment(forID: experimentID),
            let fileID = experiment.fileID else {
        isSuspended.onNext(false)
        syncRefresh.onNext(())
        return
      }
      
      driveFetcher.file(with: fileID)
        .subscribe { file in
          if let version = file?.lastSyncedVersion {
            metadataManager.localSyncStatus.setExperimentDirty(true, withID: experimentID)
            metadataManager.localSyncStatus.setExperimentLastSyncedVersion(version, withID: experimentID)
            metadataManager.saveLocalSyncStatus()
          }
        } onDisposed: { [weak self] in
          self?.isSuspended.onNext(false)
          self?.syncRefresh.onNext(())
        }
        .disposed(by: disposeBag)
    } else {
      metadataManager.localSyncStatus.setExperimentDirty(false, withID: experimentID)
      metadataManager.saveLocalSyncStatus()
      isSuspended.onNext(false)
      syncRefresh.onNext(())
    }
  }
  
  func tearDown() {
    isStarted.onNext(false)
  }
}

private extension ArduinoSyncManager {
  func startSyncEngine() {
    guard syncSubscription == nil else { return }
    
    sjlog_debug("Drive sync engine started", category: .drive)
    
    syncSubscription = syncRefresh.asObservable()
      .observe(on: MainScheduler.instance)
      .do(onNext: { [unowned self] _ in
        sjlog_debug("Drive sync started", category: .drive)
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        self.delegate?.driveSyncWillUpdateExperimentLibrary()
      })
      .flatMapLatest { [unowned self] in sync() }
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.delegate?.driveSyncDidUpdateExperimentLibrary()
        if let backgroundTask = self?.backgroundTask, backgroundTask != .invalid {
          UIApplication.shared.endBackgroundTask(backgroundTask)
          self?.backgroundTask = .invalid
        }
        sjlog_debug("Drive sync finished", category: .drive)
      })
  }
  
  func stopSyncEngine() {
    guard let subscription = syncSubscription else { return }
    
    sjlog_debug("Drive sync engine stopped", category: .drive)
    
    syncSubscription = nil
    subscription.dispose()
  }
  
  func suspend() {
    isSuspended.onNext(true)
  }
  
  func sync() -> Observable<Void> {
    checkSyncFolder()
      .flatMap { [unowned self] in self.fetchDriveFiles() }
      .flatMap { [unowned self] in self.cleanDeletedExperiments(files: $0) }
      .flatMap { [unowned self] in self.deleteMissingExperiments(files: $0) }
      .flatMap { [unowned self] in self.uploadNewExperiments(files: $0) }
      .flatMap { [unowned self] in self.uploadDirtyExperiments(files: $0) }
      .flatMap { [unowned self] in self.downloadExperiments(files: $0) }
      .catch { error in
        switch error {
        case DriveFetcher.Error.invalidToken:
          self.tearDown()
          self.delegate?.driveSyncDidFail(with: .invalidToken)
        case ArduinoSyncManagerError.missingSyncFolder:
          self.tearDown()
          self.delegate?.driveSyncDidFail(with: .missingSyncFolder)
        case ArduinoSyncManagerError.conflict(let experiment, let file):
          self.suspend()
          self.delegate?.driveSyncDidFail(with: .conflict(experiment, file))
        default:
          self.delegate?.driveSyncDidFail(with: .error(error))
        }
        
        return .just(())
      }
  }
  
  func checkSyncFolder() -> Observable<Void> {
    return driveFetcher.file(with: folderID)
      .map {
        if let file = $0, file.trashed != 1 {
          return ()
        } else {
          throw ArduinoSyncManagerError.missingSyncFolder
        }
      }
  }
  
  func fetchDriveFiles() -> Observable<[GTLRDrive_File]> {
    let comps = [
      "mimeType = 'application/zip'",
      "trashed = false",
      "'\(folderID)' in parents"
    ]
    let query = comps.joined(separator: " and ")
    return driveFetcher.find(with: query)
      .map {
        $0.filter({ $0.name?.lowercased().hasSuffix(".sj") ?? false })
      }
      .do(onNext: {
        sjlog_debug("\($0.count) experiments found on Drive", category: .drive)
      }, onSubscribe: {
        sjlog_debug("Fetching files from Drive...", category: .drive)
      })
  }
  
  func cleanDeletedExperiments(files: [GTLRDrive_File]) -> Observable<[GTLRDrive_File]> {
    let library = metadataManager.experimentLibrary
    
    var deletes = [Observable<Void>]()
    
    for experiment in library.syncExperiments where experiment.isDeleted {
      if experiment.fileID != nil {
        // delete the experiment from Drive if it doesn't exist locally anymore
        deletes.append(delete(experiment: experiment))
      } else {
        // nothing to delete on Drive, just cleanup the experiment library
        library.removeExperiment(withID: experiment.experimentID)
        metadataManager.saveExperimentLibrary()
      }
    }
    
    guard !deletes.isEmpty else {
      sjlog_debug("Nothing to delete from Drive", category: .drive)
      return .just(files)
    }
    
    return Observable.zip(deletes)
      .do(onNext: {
        sjlog_debug("\($0.count) experiments deleted from Drive", category: .drive)
      }, onSubscribe: {
        sjlog_debug("Deleting experiments from Drive...", category: .drive)
      })
      .flatMap { [unowned self] _ in fetchDriveFiles() }
  }
  
  func deleteMissingExperiments(files: [GTLRDrive_File]) -> Observable<[GTLRDrive_File]> {
    let library = metadataManager.experimentLibrary
    
    for experiment in library.syncExperiments {
      // Remove the experiment if it doesn't exist on Drive anymore
      if experiment.fileID != nil && !files.hasExperiment(with: experiment.experimentID) {
        experiment.fileID = nil
        library.removeExperiment(withID: experiment.experimentID)
        metadataManager.saveExperimentLibrary()
        experimentDataDeleter.permanentlyDeleteExperiment(withID: experiment.experimentID)
        sjlog_debug("Local experiment deleted because it wasn't find on Drive (id = \(experiment.experimentID))",
                    category: .drive)
      }
    }
    
    return .just(files)
  }
  
  func uploadNewExperiments(files: [GTLRDrive_File]) -> Observable<[GTLRDrive_File]> {
    let library = metadataManager.experimentLibrary
    
    var uploads = [Observable<GTLRDrive_File>]()
    
    for experiment in library.syncExperiments where experiment.fileID == nil {
      // upload new experiments to Drive
      uploads.append(upload(experiment))
    }
    
    guard !uploads.isEmpty else {
      sjlog_debug("Nothing new to upload to Drive", category: .drive)
      return .just(files)
    }
    
    return Observable.zip(uploads)
      .do(onNext: {
        sjlog_debug("\($0.count) new experiments uploaded to Drive", category: .drive)
      }, onSubscribe: {
        sjlog_debug("Uploading new experiments to Drive...", category: .drive)
      })
      .flatMap { [unowned self] _ in fetchDriveFiles() }
  }
  
  func uploadDirtyExperiments(files: [GTLRDrive_File]) -> Observable<[GTLRDrive_File]> {
    let library = metadataManager.experimentLibrary
    let localSyncStatus = metadataManager.localSyncStatus
    
    var updates = [Observable<GTLRDrive_File>]()
    
    for experiment in library.syncExperiments where experiment.fileID != nil {
      guard let isDirty = localSyncStatus.isExperimentDirty(withID: experiment.experimentID), isDirty else {
        continue
      }
      
      // update changed experiments to Drive
      updates.append(updateDirty(experiment: experiment))
    }
    
    guard !updates.isEmpty else {
      sjlog_debug("Nothing to update on Drive", category: .drive)
      return .just(files)
    }
    
    return Observable.zip(updates)
      .do(onNext: {
        sjlog_debug("\($0.count) experiments updated on Drive", category: .drive)
      }, onSubscribe: {
        sjlog_debug("Updating dirty experiments on Drive...", category: .drive)
      })
      .flatMap { [unowned self] _ in fetchDriveFiles() }
  }
  
  func downloadExperiments(files: [GTLRDrive_File]) -> Observable<Void> {
    let library = metadataManager.experimentLibrary
    let localSyncStatus = metadataManager.localSyncStatus
    
    var downloads = [Observable<SyncExperiment>]()
    
    for file in files {
      guard let experimentID = file.experimentID else { continue }
      guard let lastSyncedVersion = file.lastSyncedVersion else { continue }
      
      if !library.hasExperiment(withID: experimentID) ||
          lastSyncedVersion > localSyncStatus.experimentLastSyncedVersion(withID: experimentID) ?? 0 {
        
        // download newer experiment from Drive
        downloads.append(download(file: file))
      }
    }

    guard !downloads.isEmpty else {
      sjlog_debug("Nothing new to download from Drive", category: .drive)
      return .just(())
    }
    
    return Observable.zip(downloads)
      .do(onNext: {
        sjlog_debug("\($0.count) experiments downloaded from Drive", category: .drive)
      }, onSubscribe: {
        sjlog_debug("Downloading updated experiments from Drive...", category: .drive)
      })
      .map { _ in () }
  }
}

private extension ArduinoSyncManager {
  var userAgent: String { "iOS" }
  
  func archive(experiment: SyncExperiment) -> Observable<URL> {
    guard let archiveOperation = DriveSyncExportOperation(experimentID: experiment.experimentID,
                                                          metadataManager: metadataManager,
                                                          sensorDataManager: sensorDataManager) else {
      return .error(ArduinoSyncManagerError.exportError)
    }
    
    let operationQueue = self.operationQueue
    
    return Observable.create { observer in
      let completion = BlockObserver(finishHandler: { operation, errors in
        if !errors.isEmpty, let error = errors.first {
          sjlog_error("Error archiving experiment (id = \(experiment.experimentID)): \(error.localizedDescription)",
                      category: .drive)
          observer.onError(error)
          return
        }
        defer { observer.onCompleted() }
        sjlog_debug("Experiment archived (id = \(experiment.experimentID))", category: .drive)
        guard let archiveOperation = operation as? DriveSyncExportOperation else { return }
        observer.onNext(archiveOperation.documentURL)
      })
      archiveOperation.addObserver(completion)
      
      sjlog_debug("Archiving experiment... (id = \(experiment.experimentID))", category: .drive)
      
      operationQueue.addOperation(archiveOperation)
      
      return Disposables.create {
        archiveOperation.cancel()
      }
    }
  }
  
  func create(experiment: SyncExperiment) -> Observable<GTLRDrive_File> {
    guard experiment.fileID == nil else {
      sjlog_error("Trying to create an experiment that is already on Drive (id = \(experiment.experimentID))",
                  category: .drive)
      return .error(ArduinoSyncManagerError.experimentAlreadyOnDrive)
    }
    
    return self.upload(experiment)
  }
  
  func updateDirty(experiment: SyncExperiment) -> Observable<GTLRDrive_File> {
    let syncStatus = metadataManager.localSyncStatus
    
    guard let isDirty = syncStatus.isExperimentDirty(withID: experiment.experimentID), isDirty else {
      sjlog_error("Trying to update an experiment that is not dirty (id = \(experiment.experimentID))",
                  category: .drive)
      return .error(ArduinoSyncManagerError.experimentNotDirty)
    }
    
    guard let fileID = experiment.fileID else {
      sjlog_error("Trying to update an experiment that is not on Drive (id = \(experiment.experimentID))",
                  category: .drive)
      return .error(ArduinoSyncManagerError.missingFileID)
    }
    
    guard let lastSyncedVersion = syncStatus.experimentLastSyncedVersion(withID: experiment.experimentID) else {
      sjlog_error("Trying to update an experiment without last synced version (id = \(experiment.experimentID))",
                  category: .drive)
      return .error(ArduinoSyncManagerError.missingLastSyncedVersion)
    }
    
    let driveFetcher = self.driveFetcher
    return driveFetcher.file(with: fileID)
      .map { file -> Int64 in
        guard let file = file else {
          sjlog_error("Unable to find the experiment on Drive (id = \(experiment.experimentID))",
                      category: .drive)
          throw ArduinoSyncManagerError.missingExperimentOnDrive
        }
        
        guard lastSyncedVersion == file.lastSyncedVersion else {
          sjlog_debug("Found a conflict between experiment versions (id = \(experiment.experimentID))",
                      category: .drive)
          throw ArduinoSyncManagerError.conflict(experiment, file)
        }
        
        return lastSyncedVersion + 1
      }
      .flatMap { [unowned self] in
        self.upload(experiment, to: fileID, revision: $0)
      }
  }
  
  func upload(_ experiment: SyncExperiment,
              to fileID: String? = nil,
              revision: Int64? = nil) -> Observable<GTLRDrive_File> {
    let metadataManager = self.metadataManager
    
    return archive(experiment: experiment)
      .flatMap { [unowned self] url -> Observable<GTLRDrive_File> in
        let appProperties: [String: Any] = [
          GTLRDrive_File.SJAppProperty.scienceJournalFlag.rawValue: true,
          GTLRDrive_File.SJAppProperty.experimentID.rawValue: experiment.experimentID,
          GTLRDrive_File.SJAppProperty.userAgent.rawValue: userAgent,
          GTLRDrive_File.SJAppProperty.lastSyncedVersion.rawValue: revision ?? 1,
          GTLRDrive_File.SJAppProperty.fileVersion.rawValue:
            "\(Experiment.Version.major).\(Experiment.Version.minor).\(Experiment.Version.platform)",
          GTLRDrive_File.SJAppProperty.isArchived.rawValue: experiment.isArchived
        ]
        
        guard let fileID = fileID else {
          sjlog_debug("Creating experiment on Drive (id = \(experiment.experimentID))",
                      category: .drive)
          return driveFetcher.uploadMultipart(from: url,
                                              mimeType: "application/zip",
                                              to: folderID,
                                              appProperties: appProperties)
          
        }
        sjlog_debug("Updating experiment on Drive (id = \(experiment.experimentID))",
                    category: .drive)
        return driveFetcher.updateMultipart(from: url,
                                            mimeType: "application/zip",
                                            to: fileID,
                                            appProperties: appProperties)
      }
      .do(onNext: { file in
        if let fileID = file.identifier, let version = file.lastSyncedVersion {
          sjlog_debug("Experiment uploaded to Drive (id = \(experiment.experimentID), file = \(fileID), version = \(version))",
                      category: .drive)
          
          let library = metadataManager.experimentLibrary
          library.setFileID(fileID, forExperimentID: experiment.experimentID)
          
          let syncStatus = metadataManager.localSyncStatus
          syncStatus.setExperimentLastSyncedVersion(version, withID: experiment.experimentID)
          syncStatus.setExperimentDirty(false, withID: experiment.experimentID)
          
          metadataManager.saveExperimentLibrary()
          metadataManager.saveLocalSyncStatus()
        }
      })
  }
  
  func delete(experiment: SyncExperiment) -> Observable<Void> {
    let metadataManager = self.metadataManager
    
    let cleanup = {
      metadataManager.experimentLibrary.removeExperiment(withID: experiment.experimentID)
      metadataManager.localSyncStatus.removeExperiment(withID: experiment.experimentID)
      
      metadataManager.saveExperimentLibrary()
      metadataManager.saveLocalSyncStatus()
    }
    
    guard let fileID = experiment.fileID else {
      cleanup()
      return .error(ArduinoSyncManagerError.missingFileID)
    }
    
    return driveFetcher.deleteFile(with: fileID)
      .do(onNext: { _ in
        cleanup()
      })
  }
  
  func download(file: GTLRDrive_File) -> Observable<SyncExperiment> {
    let metadataManager = self.metadataManager
    let syncStatus = metadataManager.localSyncStatus
    
    guard let fileID = file.identifier else {
      return .error(ArduinoSyncManagerError.missingFileID)
    }
    
    guard let experimentID = file.experimentID else {
      return .error(ArduinoSyncManagerError.missingExperimentID)
    }
    
    guard let lastSyncedVersion = file.lastSyncedVersion else {
      return .error(ArduinoSyncManagerError.missingLastSyncedVersion)
    }
    
    if let isDirty = syncStatus.isExperimentDirty(withID: experimentID), isDirty,
       let experiment = metadataManager.experimentLibrary.syncExperiment(forID: experimentID) {
      return .error(ArduinoSyncManagerError.conflict(experiment, file))
    }
    
    var title: String?
    if let name = file.name, name.hasSuffix(".sj") {
      title = String(name.dropLast(3))
    }
    
    let lastUsedDate = file.modifiedTime?.date
    
    return driveFetcher.download(file)
      .flatMap { [unowned self] in
        importExperiment($0, experimentID: experimentID, title: title, lastUsedDate: lastUsedDate)
      }
      .observe(on: MainScheduler.instance)
      .do(onNext: { [unowned self] _ in
        metadataManager.experimentLibrary.setFileID(fileID, forExperimentID: experimentID)
        metadataManager.localSyncStatus.setExperimentLastSyncedVersion(lastSyncedVersion, withID: experimentID)
        metadataManager.localSyncStatus.setExperimentDirty(false, withID: experimentID)
        metadataManager.setArchivedState(file.isArchived, forExperimentWithID: experimentID)
        metadataManager.saveExperimentLibrary()
        metadataManager.saveLocalSyncStatus()
        
        if let experiment = metadataManager.experiment(withID: experimentID) {
          self.delegate?.driveSyncDidUpdateExperiment(experiment)
        }
      })
  }
  
  func importExperiment(_ data: Data, experimentID: String?, title: String?, lastUsedDate: Date?) -> Observable<SyncExperiment> {
    // Importing when the app is recording is not supported.
    guard !RecordingState.isRecording else {
      return .error(ArduinoSyncManagerError.importingDocumentWhileRecording)
    }

    let fileManager = FileManager.default
    let experimentID = experimentID ?? UUID().uuidString
    
    let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(experimentID)
    if fileManager.fileExists(atPath: tempDirectoryURL.path) {
      do {
        try fileManager.removeItem(at: tempDirectoryURL)
      } catch {
        return .error(ArduinoSyncManagerError.filesystemError)
      }
    }
    
    let sourceURL = tempDirectoryURL.appendingPathComponent(experimentID).appendingPathExtension("sj")
    do {
      try fileManager.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true, attributes: nil)
      try data.write(to: sourceURL)
    } catch {
      return .error(ArduinoSyncManagerError.filesystemError)
    }
    
    let zipURL = tempDirectoryURL.appendingPathComponent(experimentID).appendingPathExtension("zip")
    let extractionURL = tempDirectoryURL.appendingPathComponent(experimentID).appendingPathComponent("files")
    let experimentURL = metadataManager.experimentDirectoryURL(for: experimentID)
    
    let importDocumentOperation =
        ImportDocumentOperation(sourceURL: sourceURL,
                                zipURL: zipURL,
                                extractionURL: extractionURL,
                                experimentURL: experimentURL,
                                sensorDataManager: sensorDataManager,
                                metadataManager: metadataManager)

    let metadataManager = self.metadataManager
    let operationQueue = self.operationQueue
    return Observable.create { observer -> Disposable in
      let observer = BlockObserver(finishHandler: { (operation, _) in
        try? fileManager.removeItem(at: tempDirectoryURL)
        
        if !operation.didFinishSuccessfully {
          observer.onError(ArduinoSyncManagerError.importError)
        } else {
          if !metadataManager.experimentLibrary.hasExperiment(withID: experimentID) {
            metadataManager.addImportedExperiment(withID: experimentID)
          } else {
            metadataManager.setExperimentTitle(title, forID: experimentID)
          }
          if let date = lastUsedDate {
            metadataManager.setLastUsedDate(date, forExperimentWithID: experimentID)
          }
          metadataManager.saveUserMetadata()
          
          guard let experiment = metadataManager.experimentLibrary.syncExperiment(forID: experimentID) else {
            observer.onError(ArduinoSyncManagerError.importError)
            return
          }
          observer.onNext(experiment)
          observer.onCompleted()
        }
      })
      importDocumentOperation.addObserver(observer)
      importDocumentOperation.addObserver(BackgroundTaskObserver())
      operationQueue.addOperation(importDocumentOperation)
      
      return Disposables.create { importDocumentOperation.cancel() }
    }
  }
}
