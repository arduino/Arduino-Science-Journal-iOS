//  
//  DriveSyncSummaryViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 12/01/21.
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

class DriveSyncSummaryViewController: WizardViewController {

  let folder: DriveManager.Folder

  private(set) lazy var summaryView = DriveSyncSummaryView(folderName: folder.name)
  
  init(folder: DriveManager.Folder) {
    self.folder = folder
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    wizardView.title = String.driveSyncSummaryTitle
    wizardView.text = String(format: String.driveSyncSummaryText, folder.name)
    wizardView.contentView = summaryView
    
    summaryView.startButton.addTarget(self, action: #selector(start(_:)), for: .touchUpInside)
  }
  
  @objc private func start(_ sender: UIButton) {
    self.close(sender)
  }

}
