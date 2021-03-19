//  
//  GTLRDrive_File+ScienceJournal.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 05/03/21.
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

import GoogleAPIClientForREST

extension GTLRDrive_File {
  enum SJAppProperty: String {
    case scienceJournalFlag = "scienceJournalExperiment"
    case experimentID = "experimentID"
    case fileVersion = "fileVersion"
    case lastSyncedVersion = "version"
    case userAgent = "userAgent"
    case isArchived = "isArchived"
  }
  
  var isVersionCompatible: Bool {
    guard let fileVersion = fileVersion else { return false }
    let currentVersion = FileVersion(major: Experiment.Version.major,
                                     minor: Experiment.Version.minor,
                                     platform: Experiment.Version.platform)
    return fileVersion <= currentVersion
  }
  
  var isArchived: Bool {
    guard let properties = appProperties else {
      return false
    }
    guard let isArchived = properties.additionalProperty(forName: SJAppProperty.isArchived.rawValue) as? String else {
      return false
    }
    return isArchived == "true"
  }
  
  var experimentID: String? {
    guard let properties = appProperties else {
      return nil
    }
    return properties.additionalProperty(forName: SJAppProperty.experimentID.rawValue) as? String
  }
  
  var fileVersion: FileVersion? {
    guard let properties = appProperties else {
      return nil
    }
    guard let versionString = properties.additionalProperty(forName: SJAppProperty.fileVersion.rawValue) as? String else {
      return nil
    }
    
    let versionComponents = versionString.split(separator: ".").compactMap({ Int32($0) })
    guard versionComponents.count == 3 else {
      return nil
    }
    
    return FileVersion(major: versionComponents[0],
                       minor: versionComponents[1],
                       platform: versionComponents[2])
  }
  
  var lastSyncedVersion: Int64? {
    guard let properties = appProperties else {
      return nil
    }
    guard let versionString = properties.additionalProperty(forName: SJAppProperty.lastSyncedVersion.rawValue) as? String else {
      return nil
    }
    return Int64(versionString)
  }
}

extension Array where Element == GTLRDrive_File {
  func hasExperiment(with identifier: String) -> Bool {
    first { $0.experimentID == identifier } != nil
  }
  
  func experiment(with identifier: String) -> GTLRDrive_File? {
    first { $0.experimentID == identifier }
  }
}
