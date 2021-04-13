//  
//  SignUpConfirmationView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 29/03/21.
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

class SignUpConfirmationView: UIStackView {

  let resendButton = WizardButton(title: String.arduinoSignUpEmailConfirmationResendButton, style: .system)
  let backButton = WizardButton(title: String.arduinoSignUpEmailConfirmationBackButton, style: .solid)
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignUpEmailConfirmationTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let textLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignUpEmailConfirmationText
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  init() {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    spacing = 0
    
    addArrangedSubview(titleLabel, customSpacing: 36)
    addArrangedSubview(textLabel, customSpacing: 40)
    addArrangedSubview(resendButton, customSpacing: 72)
    addArrangedSubview(backButton)
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}
