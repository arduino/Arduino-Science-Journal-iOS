/*
 *  Copyright 2019 Google LLC. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import Foundation
import GoogleAPIClientForREST

public protocol DriveSyncManagerDelegate: class {
  /// Informs the delegate the experiment library will be updated.
  func driveSyncWillUpdateExperimentLibrary()

  /// Informs the delegate the experiment library was updated.
  func driveSyncDidUpdateExperimentLibrary()

  /// Informs the delegate an experiment was updated or is newly downloaded.
  ///
  /// - Parameter experiment: An experiment.
  func driveSyncDidUpdateExperiment(_ experiment: Experiment)

  /// Informs the delegate an experiment was deleted.
  ///
  /// - Parameter experimentID: An experiment ID.
  func driveSyncDidDeleteExperiment(withID experimentID: String)

  /// Informs the delegate a trial was deleted from an experiment.
  ///
  /// - Parameter trialID: A trial ID.
  /// - Parameter experimentID: An experimentID from which the trial was deleted.
  func driveSyncDidDeleteTrial(withID trialID: String, experimentID: String)
  
  /// Informs the delegate of an error while trying to sync.
  ///
  /// - Parameter error: The occurred error.
  func driveSyncDidFail(with error: DriveSyncManagerError)
}

extension Notification.Name {
  /// Posted when image asset downloads complete. Access the paths of the downloaded images with
  /// DriveSyncUserInfoConstants.downloadedImagePathsKey.
  public static let driveSyncManagerDownloadedImages =
      NSNotification.Name("DriveSyncManagerDownloadedImages")

  /// Posted when sensor data downloads complete. Access the IDs of the trials the sensor data
  /// belongs to with DriveSyncUserInfoConstants.downloadedSensorDataTrialIDsKey.
  public static let driveSyncManagerDownloadedSensorData =
      NSNotification.Name("DriveSyncManagerDownloadedImages")
}

/// A protocol that defines a manager object for Drive sync.
public protocol DriveSyncManager: class {
  
  /// A delegate that will be informed when Drive Sync changes data.
  var delegate: DriveSyncManagerDelegate? { get set }

  /// Syncs the experiment library and uploads new experiments.
  func syncExperimentLibrary()

  /// Syncs one experiment.
  ///
  /// - Parameters:
  ///   - experimentID: An experiment ID.
  ///   - condition: The condition under which to sync.
  func syncExperiment(withID experimentID: String, condition: DriveExperimentSyncCondition)

  /// Syncs trial sensor data to Drive.
  ///
  /// - Parameters:
  ///   - url: The URL of the trial sensor data proto on disk.
  ///   - experimentID: The ID of the experiment that owns the trial.
  func syncTrialSensorData(atURL url: URL, experimentID: String)

  /// Deletes an experiment from Drive.
  ///
  /// - Parameter experimentID: The experiment ID.
  func deleteExperiment(withID experimentID: String)

  /// Checks Drive to see if the experiment library exists.
  ///
  /// - Parameter completion: A completion block called when the search is finished with a Bool
  ///                         parameter indicating whether the library exists. Nil indicates the
  ///                         existence could not be determined.
  func experimentLibraryExists(completion: @escaping (Bool?) -> Void)

  /// Deletes image assets from Drive.
  ///
  /// - Parameters:
  ///   - urls: The local urls of the image assets.
  ///   - experimentID: The ID of the experiment the image asset belongs to.
  func deleteImageAssets(atURLs urls: [URL], experimentID: String)

  /// Deletes a sensor data asset from Drive.
  ///
  /// - Parameters:
  ///   - url: The local url of the sensor data asset.
  ///   - experimentID: The ID of the experiment the sensor data asset belongs to.
  func deleteSensorDataAsset(atURL url: URL, experimentID: String)
  
  /// Resolve a conflict between the local experiment and the Drive one.
  ///
  /// - Parameters:
  ///   - experimentID: The experiment ID.
  ///   - overwriteRemote: Pass `true` if you want to overwrite the experiment on Drive with the local one,
  ///                      `false` to download the Drive experiment replacing the local one.
  func resolveConflictOfExperiment(withID experimentID: String, overwritingRemote: Bool)

  /// Prepare for Drive sync shutting down. All sync operations should be cancelled.
  func tearDown()

}

// MARK: - DriveExperimentSyncCondition

public enum DriveExperimentSyncCondition {
  /// Only sync the experiment if either the local or remote experiment is dirty.
  case onlyIfDirty
  /// Sync the experiment regardless of dirty state.
  case always
}

// MARK: - DriveSyncManagerError

public enum DriveSyncManagerError: Error {
  /// This error occurs when the Drive token has expired or has been revoked.
  case invalidToken
  /// This error occurs when the Drive folder used for sync has been deleted.
  case missingSyncFolder
  /// This error occurs when both Drive and local experiments have been modified since last sync.
  case conflict(_ experiment: SyncExperiment, _ file: GTLRDrive_File)
  /// This error occurs when a local experiment cannot be exported.
  case exportError(_ experiment: SyncExperiment)
  /// This could be any error. For further details you can inspect the passed parameter.
  case error(_ error: Error)
}
