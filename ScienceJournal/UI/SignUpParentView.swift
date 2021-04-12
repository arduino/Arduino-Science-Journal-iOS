//  
//  SignUpParentView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 07/04/21.
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

class SignUpParentView: UIStackView {

  let emailTextField = WizardTextField(placeholder: String.arduinoParentEmailPlaceholder,
                                       isRequired: true)
  let emailConfirmationTextField = WizardTextField(placeholder: String.arduinoParentEmailConfirmationPlaceholder,
                                                   isRequired: true)
  
  let submitButton = WizardButton(title: String.arduinoParentEmailSubmit, isSolid: true)
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoParentEmailTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoParentEmailSubtitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  init(isJunior: Bool) {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    spacing = 20
    
    if isJunior {
      subtitleLabel.text = String.arduinoSignUpJuniorParentEmailSubtitle
    } else {
      subtitleLabel.text = String.arduinoParentEmailSubtitle
    }
    
    addArrangedSubview(titleLabel)
    addArrangedSubview(subtitleLabel)
    addArrangedSubview(emailTextField, customSpacing: 28)
    addArrangedSubview(emailConfirmationTextField, customSpacing: 28)
    
    let recoverButtonStackView = UIStackView()
    recoverButtonStackView.axis = .horizontal
    recoverButtonStackView.addArrangedSubview(UIView())
    recoverButtonStackView.addArrangedSubview(submitButton)
    addArrangedSubview(recoverButtonStackView)
    
    NSLayoutConstraint.activate([
      emailTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),
      emailConfirmationTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
      recoverButtonStackView.widthAnchor.constraint(equalTo: emailConfirmationTextField.widthAnchor)
    ])
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

}