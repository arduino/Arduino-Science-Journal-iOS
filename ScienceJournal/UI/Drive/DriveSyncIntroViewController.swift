//  
//  DriveSyncIntroViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 05/01/21.
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
import MaterialComponents.MaterialSnackbar

class DriveSyncIntroViewController: WizardViewController {

  private(set) lazy var introView = DriveSyncIntroView()

  override func viewDidLoad() {
    super.viewDidLoad()

    wizardView.title = String.driveSyncIntroTitle
    wizardView.text = String.driveSyncIntroText
    wizardView.contentView = introView

    introView.learnMoreButton.addTarget(self, action: #selector(showMoreInfo(_:)), for: .touchUpInside)
    introView.googleDriveButton.addTarget(self, action: #selector(setupGoogleDrive(_:)), for: .touchUpInside)
    introView.skipButton.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
  }

  @objc private func showMoreInfo(_ sender: UIButton) {
    let alertController = MDCAlertController(title: nil,
                                             message: String.driveSyncIntroMoreText)
    alertController.addAction(MDCAlertAction(title: String.actionOk))
    alertController.accessibilityViewIsModal = true
    present(alertController, animated: true)
  }

  @objc private func setupGoogleDrive(_ sender: UIButton) {

  }
}
