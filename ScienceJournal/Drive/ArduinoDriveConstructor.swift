//  
//  ArduinoDriveConstructor.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 04/02/21.
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

import googlemac_iPhone_Shared_SSOAuth_SSOAuth

open class ArduinoDriveConstructor: DriveConstructor {

  public init() {}

  public func driveSyncManager(withAuthorization authorization: GTMFetcherAuthorizationProtocol,
                               experimentDataDeleter: ExperimentDataDeleter,
                               metadataManager: MetadataManager,
                               networkAvailability: NetworkAvailability,
                               preferenceManager: PreferenceManager,
                               sensorDataManager: SensorDataManager,
                               analyticsReporter: AnalyticsReporter) -> DriveSyncManager? {
    
    guard let folderID = preferenceManager.driveSyncFolderID else { return nil }
  
    let service = GTLRDriveService()
    service.authorizer = authorization
    service.shouldFetchNextPages = true
    
    return ArduinoSyncManager(metadataManager: metadataManager,
                              sensorDataManager: sensorDataManager,
                              experimentDataDeleter: experimentDataDeleter,
                              driveFetcher: DriveFetcher(service: service),
                              folderID: folderID)
  }

}
