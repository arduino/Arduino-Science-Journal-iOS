//  
//  SignUpParentConfirmationView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 08/04/21.
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

class SignUpParentConfirmationView: UIStackView {

  let closeButton = WizardButton(title: String.arduinoParentConfirmationButton, isSolid: true)
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoParentConfirmationTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    label.numberOfLines = 0
    return label
  }()

  init(parentEmail: String) {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    spacing = 20
    
    subtitleLabel.text = String(format: String.arduinoParentConfirmationSubtitle, parentEmail)
    
    addArrangedSubview(titleLabel)
    addArrangedSubview(subtitleLabel, customSpacing: 50)
    addArrangedSubview(closeButton)
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

}
