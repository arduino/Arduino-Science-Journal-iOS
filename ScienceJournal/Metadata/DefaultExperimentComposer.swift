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
    addIntroNote(experiment: experiment)
    addNewExperimentNote(experiment: experiment)
    addToolbarNote(experiment: experiment)
    addActionAreaNote(experiment: experiment)
    addSensorNote(experiment: experiment)
    addSensorSettingsNote(experiment: experiment)
    addNotesNote(experiment: experiment)
    addSnapshotNote(experiment: experiment)
    addPhotosNote(experiment: experiment)
    addActivitiesNote(experiment: experiment)
    
  }
  
  // swiftlint:disable line_length
  private func addIntroImage(experiment: Experiment) {
    if let defaultExperimentPicture = UIImage(named: "default_experiment_picture") {
      let coverPicturePath = metaDataManager.relativePicturePath(for: "default_experiment_picture")
      metaDataManager.saveImage(defaultExperimentPicture, atPicturePath: coverPicturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 100
      pictureNote.caption = Caption(text: "Shape your future! Reason with data and think like a real scientist! Turn your phone into a pocket science laboratory with tools to measure light, motion, sound and more!")
             
      //pictureNote.caption = Caption(text: String.firstExperimentPictureNoteCaption)
      pictureNote.filePath = coverPicturePath
      experiment.notes.append(pictureNote)
      metaDataManager.updateCoverImageForAddedImageIfNeeded(imagePath: coverPicturePath, experiment: experiment)
    }
  }
  
  private func addIntroNote(experiment: Experiment) {
    //let textNote = TextNote(text: String.firstExperimentTextNote)
    let textNote = TextNote(text: "Arduino Science Journal is a digital science journal that you can use to document projects through notes, photos, and your phone's built-in sensors, as well as external boards.")
    textNote.timestamp = timestamp + 200
    experiment.notes.append(textNote)
  }
  
  private func addNewExperimentNote(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_new_experiment") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_new_experiment")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 300
      pictureNote.caption = Caption(text: "To create a new experiment, click one the + in the bottom of the Arduino Science Journal app home screen. Then click on the pencil icon in the top to give your experiment a good name!")
       
      //pictureNote.caption = Caption(text: String.firstExperimentPictureNoteCaption)
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addToolbarNote(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_toolbar") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_toolbar")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 400
      pictureNote.caption = Caption(text: "The observation toolbar in the app can help you record the data around you. Let’s take a look!")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addActionAreaNote(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_action_area") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_action_area")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 400
      pictureNote.caption = Caption(text: "The observation toolbar in the app can help you record the data around you. Let’s take a look!")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addSensorNote(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_sensor_button") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_sensor_button")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 500
      pictureNote.caption = Caption(text: "To start exploring your world by measuring light, sound, movement, and more, tap the Sensor button.")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addSensorSettingsNote(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_sensor_settings") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_sensor_settings")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 600
      pictureNote.caption = Caption(text: "You can manage your sensors in the Sensor settings screen. Go back to the sensor tab in the toolbar and tap the Gear icon on the sensor card.")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addNotesNote(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_note_button") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_note_button")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 700
      pictureNote.caption = Caption(text: "You can add notes and hypotheses to your experiments by tapping the Note icon.")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addSnapshotNote(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_snapshot_button") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_snapshot_button")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 800
      pictureNote.caption = Caption(text: "To make note of a single sensor measurement, tap the Snapshot Sensor button. You can also record sensor data over time, select a sensor and press the Record button to start capturing data.")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addPhotosNote(experiment: Experiment) {
    if let picture = UIImage(named: "default_experiment_camera") {
      let picturePath = metaDataManager.relativePicturePath(for: "default_experiment_camera")
      metaDataManager.saveImage(picture, atPicturePath: picturePath, experimentID: experiment.ID)
      let pictureNote = PictureNote()
      pictureNote.timestamp = timestamp + 1000
      pictureNote.caption = Caption(text: "Add camera shots, notes and photos to keep track of your observations while recording.")
      pictureNote.filePath = picturePath
      experiment.notes.append(pictureNote)
    }
  }
  
  private func addActivitiesNote(experiment: Experiment) {
    let textNote = TextNote(text: "Find activities to try at\nscience-journal.arduino.cc\n\nNow that you know the basics of using Arduino Science Journal, you can use it to conduct experiments and explore your world!")
    textNote.timestamp = timestamp  + 1100
    experiment.notes.append(textNote)
  }
  
  // swiftlint:enable line_length
}
