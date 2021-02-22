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

import googlemac_iPhone_Shared_SSOAuth_SSOAuth
import GTMSessionFetcher

final class ArduinoSyncManager: DriveSyncManager {
  let authorization: GTMFetcherAuthorizationProtocol
  let folderID: String
  
  weak var delegate: DriveSyncManagerDelegate?
  
  init(authorization: GTMFetcherAuthorizationProtocol, folderID: String) {
    self.authorization = authorization
    self.folderID = folderID
  }
  
  func syncExperimentLibrary(andReconcile shouldReconcile: Bool, userInitiated: Bool) {
    
  }
  
  func syncExperiment(withID experimentID: String, condition: DriveExperimentSyncCondition) {
    
  }
  
  func syncTrialSensorData(atURL url: URL, experimentID: String) {
    
  }
  
  func deleteExperiment(withID experimentID: String) {
    
  }
  
  func experimentLibraryExists(completion: @escaping (Bool?) -> Void) {
    completion(false)
  }
  
  func deleteImageAssets(atURLs urls: [URL], experimentID: String) {
    
  }
  
  func deleteSensorDataAsset(atURL url: URL, experimentID: String) {
    
  }
  
  func tearDown() {
    
  }
  
}
