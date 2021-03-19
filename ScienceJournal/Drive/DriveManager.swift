//  
//  DriveManager.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 08/01/21.
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
import GoogleAPIClientForREST
import RxSwift

extension DriveManager {
  class Folder: Equatable {
    let id: String
    let name: String
    let parent: Folder?

    init?(file: GTLRDrive_File, parent: Folder?) {
      guard let id = file.identifier,
            let name = file.name else {
        return nil
      }

      self.id = id
      self.name = name
      self.parent = parent
    }
    
    static func == (lhs: DriveManager.Folder, rhs: DriveManager.Folder) -> Bool {
      lhs.id == rhs.id
    }
  }
  
  enum Error: Swift.Error {
    case invalidToken(NSError)
    case unreadableData
    case invalidFile
  }
}

class DriveManager {
  let service: GTLRDriveService

  init(service: GTLRDriveService) {
    self.service = service
  }

  func subfolders(in folder: Folder? = nil) -> Observable<[Folder]> {
    let q: String
    if let parentFolder = folder {
      q = "mimeType = 'application/vnd.google-apps.folder' and trashed = false and '\(parentFolder.id)' in parents"
    } else {
      q = "mimeType = 'application/vnd.google-apps.folder' and trashed = false and 'root' in parents"
    }

    let query = GTLRDriveQuery_FilesList.query()
    query.pageSize = 100
    query.orderBy = "name"
    query.q = q
    query.fields = "files(id,name,parents),nextPageToken"

    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { [weak self] _, files, error in
        if let error = error {
          self?.handle(error, with: observer)
          return
        }

        defer { observer.onCompleted() }

        guard let filesList = files as? GTLRDrive_FileList,
              let files = filesList.files else {
          return
        }

        let subfolders = files.compactMap {
          Folder(file: $0, parent: folder)
        }

        observer.onNext(subfolders)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }

  func createFolder(named folderName: String, in parentFolder: Folder?) -> Observable<Folder> {
    let file = GTLRDrive_File()
    file.name = folderName
    file.mimeType = "application/vnd.google-apps.folder"

    if let parentFolder = parentFolder {
      file.parents = [parentFolder.id]
    }

    let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: nil)
    query.fields = "id,name"
    
    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { [weak self] _, file, error in
        if let error = error {
          self?.handle(error, with: observer)
          return
        }
        
        defer { observer.onCompleted() }

        guard let file = file as? GTLRDrive_File,
              let folder = Folder(file: file, parent: parentFolder) else {
          return
        }

        observer.onNext(folder)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }
  
  func find(with q: String) -> Observable<[GTLRDrive_File]> {
    let query = GTLRDriveQuery_FilesList.query()
    query.pageSize = 100
    query.q = q
    query.fields = "files(id,name,appProperties),nextPageToken"
    
    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { [weak self] _, files, error in
        if let error = error {
          self?.handle(error, with: observer)
          return
        }

        defer { observer.onCompleted() }

        guard let filesList = files as? GTLRDrive_FileList,
              let files = filesList.files else {
          return
        }
        
        observer.onNext(files)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }
  
  func file(with fileId: String) -> Observable<GTLRDrive_File?> {
    let query = GTLRDriveQuery_FilesGet.query(withFileId: fileId)
    query.fields = "id,name,appProperties"
    
    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { [weak self] _, file, error in
        if let error = error {
          self?.handle(error, with: observer)
          return
        }

        defer { observer.onCompleted() }

        observer.onNext(file as? GTLRDrive_File)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }
  
  func deleteFile(with fileId: String) -> Observable<Void> {
    let query = GTLRDriveQuery_FilesDelete.query(withFileId: fileId)
    
    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { [weak self] _, _, error in
        if let error = error {
          self?.handle(error, with: observer)
          return
        }
        
        defer { observer.onCompleted() }
        
        observer.onNext(())
      })

      return Disposables.create(with: ticket.cancel)
    }
  }
  
  func uploadMultipart(from url: URL,
                       mimeType: String,
                       to folderID: String?,
                       appProperties: [AnyHashable: Any]?) -> Observable<GTLRDrive_File> {
    
    let file = GTLRDrive_File()
    file.name = url.lastPathComponent
    
    file.appProperties = GTLRDrive_File_AppProperties(json: appProperties)
    
    if let folderID = folderID {
      file.parents = [folderID]
    }
    
    guard let data = try? Data.init(contentsOf: url) else {
      return .error(Error.unreadableData)
    }
    
    let uploadParameters = GTLRUploadParameters(data: data, mimeType: mimeType)
    
    let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
    query.fields = "id,name,appProperties"
    
    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { [weak self] _, file, error in
        if let error = error {
          self?.handle(error, with: observer)
          return
        }
        
        defer { observer.onCompleted() }

        guard let file = file as? GTLRDrive_File else {
          return
        }

        observer.onNext(file)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }
  
  func updateMultipart(from url: URL,
                       to fileID: String,
                       appProperties: [AnyHashable: Any]?) -> Observable<GTLRDrive_File> {
    
    let file = GTLRDrive_File()
    file.name = url.lastPathComponent
    
    file.appProperties = GTLRDrive_File_AppProperties(json: appProperties)
    
    guard let data = try? Data.init(contentsOf: url) else {
      return .error(Error.unreadableData)
    }
    
    let uploadParameters = GTLRUploadParameters()
    uploadParameters.data = data
    
    let query = GTLRDriveQuery_FilesUpdate.query(withObject: file, fileId: fileID, uploadParameters: uploadParameters)
    query.fields = "id,name,appProperties"
    
    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { [weak self] _, file, error in
        if let error = error {
          self?.handle(error, with: observer)
          return
        }
        
        defer { observer.onCompleted() }

        guard let file = file as? GTLRDrive_File else {
          return
        }

        observer.onNext(file)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }
  
  func download(_ file: GTLRDrive_File) -> Observable<Data> {
    guard let fileId = file.identifier else {
      return .error(Error.invalidFile)
    }
    
    let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileId)
   
    let service = self.service

    return Observable.create { observer in
      let ticket = service.executeQuery(query, completionHandler: { [weak self] _, object, error in
        if let error = error {
          self?.handle(error, with: observer)
          return
        }
        
        defer { observer.onCompleted() }
        
        guard let object = object as? GTLRDataObject else {
          return
        }
        
        observer.onNext(object.data)
      })

      return Disposables.create(with: ticket.cancel)
    }
  }
  
  private func handle<T>(_ error: Swift.Error, with observer: AnyObserver<T>) {
    switch error {
    case let error as NSError where error.domain == "org.openid.appauth.oauth_token":
      observer.onError(Error.invalidToken(error))
    default:
      observer.onError(error)
    }
  }
}
