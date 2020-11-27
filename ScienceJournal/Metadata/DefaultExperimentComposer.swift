//  
//  DefaultExperiment.swift
//  ScienceJournal
//
//  Created by Sebastian Hunkeler on 24.08.20.
//  Copyright © 2020 Arduino. All rights reserved.
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

class DefaultExperimentComposer {
  private var metaDataManager: MetadataManager
  private var timestamp: Int64 = 0
  
  init(metaDataManager: MetadataManager) {
    self.metaDataManager = metaDataManager
  }
  
  func populateDefaultExperiment(experiment : Experiment) {
    
    // Set chronological timestamps so they display in the correct order.
    timestamp = Date().millisecondsSince1970

    //TODO localize content
    addIntroImage(experiment: experiment)
    addActionAreaImage(experiment: experiment)
    addWebsiteImage(experiment: experiment)
    addSidebarImage(experiment: experiment)
  }
  
  // swiftlint:disable line_length
  private func addIntroImage(experiment: Experiment) {
    if let defaultExperimentPicture = UIImage(named: "default_experiment_picture") {
      let coverPicturePath = metaDataManager.relativePicturePath(for: "default_experiment_picture")
      metaDataManager.saveImage(defaultExperimentPicture, atPicturePath: coverPicturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 100
      pictureNote.caption = Caption(text: "Welcome to Science Journal!")
      pictureNote.filePath = coverPicturePath
      experiment.notes.append(pictureNote)
      metaDataManager.updateCoverImageForAddedImageIfNeeded(imagePath: coverPicturePath, experiment: experiment)
    }
  }
  
  private func addActionAreaImage(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_toolbar") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_toolbar")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 200
      pictureNote.caption = Caption(text: "Start taking notes and record data using the observation toolbar.")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addWebsiteImage(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_website") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_website")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 300
      pictureNote.caption = Caption(text: "Find activities and inspiration at science-journal.arduino.cc and start exploring the world around you.")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addSidebarImage(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_getting_started") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_getting_started")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 400
      pictureNote.caption = Caption(text: "If you missed the Getting Started guide or you want to go back to it, you can find it in the sidebar menu.")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  // swiftlint:enable line_length
}
