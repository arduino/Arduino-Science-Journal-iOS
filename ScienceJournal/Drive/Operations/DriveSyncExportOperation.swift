//  
//  DriveSyncExportOperation.swift
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

import UIKit

class DriveSyncExportOperation: ExportDocumentOperation {
  init?(experimentID: String,
        metadataManager: MetadataManager,
        sensorDataManager: SensorDataManager) {
   
    guard let (experiment, overview) =
        metadataManager.experimentAndOverview(forExperimentID: experimentID) else {
      sjlog_error("Failed to find experiment with ID '\(experimentID)' when exporting experiment.",
                  category: .general)
      return nil
    }

    // Migrate image path from overview if necessary.
    if experiment.imagePath == nil {
      experiment.imagePath = overview.imagePath
    }

    experiment.setTitleToDefaultIfNil()

    // Make sure there are no unsaved changes.
    metadataManager.saveExperimentWithoutDateOrDirtyChange(experiment)
    
    var coverImageURL: URL?
    if let imagePath = experiment.imagePath {
      coverImageURL = metadataManager.pictureFileURL(for: imagePath, experimentID: experiment.ID)
    }
    
    super.init(coverImageURL: coverImageURL,
               experiment: experiment,
               experimentURL: metadataManager.experimentDirectoryURL(for: experimentID),
               sensorDataManager: sensorDataManager)
  }
}
