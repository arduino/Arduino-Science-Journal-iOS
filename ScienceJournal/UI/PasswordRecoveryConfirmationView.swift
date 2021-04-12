//  
//  PasswordRecoveryConfirmationView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 23/03/21.
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

class PasswordRecoveryConfirmationView: UIStackView {

  let resendButton = WizardButton(title: String.arduinoPasswordRecoveryResendButton, style: .solid)
  let backButton = WizardButton(title: String.arduinoPasswordRecoveryBackButton, style: .solid)
  
  private let titleLabel: UILabel = {
    let label = UILabel()
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
  
  init(isAdult: Bool) {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    spacing = 0
    
    if isAdult {
      titleLabel.text = String.arduinoPasswordRecoveryConfirmationTitle
      subtitleLabel.text = String.arduinoPasswordRecoveryConfirmationSubtitle
    } else {
      titleLabel.text = String.arduinoPasswordJuniorRecoveryConfirmationTitle
      subtitleLabel.text = String.arduinoPasswordJuniorRecoveryConfirmationSubtitle
    }
    
    addArrangedSubview(titleLabel, customSpacing: 36)
    addArrangedSubview(subtitleLabel, customSpacing: 40)
    addArrangedSubview(resendButton, customSpacing: 72)
    addArrangedSubview(backButton)
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}
