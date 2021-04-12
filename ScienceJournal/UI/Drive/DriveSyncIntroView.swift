//  
//  DriveSyncIntroView.swift
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

class DriveSyncIntroView: UIStackView {
  let learnMoreButton = WizardButton(title: String.driveSyncIntroMore)
  let googleDriveButton = GoogleDriveButton()
  let skipButton = WizardButton(title: String.driveSyncIntroSkip, style: .solid)

  init() {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    spacing = 40

    addArrangedSubview(learnMoreButton)
    addArrangedSubview(googleDriveButton)

    let skipContainerView = UIView()
    addArrangedSubview(skipContainerView)
    skipContainerView.backgroundColor = UIColor.clear
    skipContainerView.addSubview(skipButton)
    skipButton.translatesAutoresizingMaskIntoConstraints = false
    skipButton.pinToEdgesOfView(skipContainerView, andEdges: [.top, .bottom, .trailing])
    skipButton.trailingAnchor.constraint(equalTo: googleDriveButton.trailingAnchor).isActive = true
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}
