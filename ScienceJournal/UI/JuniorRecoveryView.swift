//  
//  JuniorRecoveryView.swift
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

class JuniorRecoveryView: UIStackView {

  let usernameTextField = WizardTextField(placeholder: String.arduinoPasswordJuniorRecoveryUsernamePlaceholder)
  let emailTextField = WizardTextField(placeholder: String.arduinoPasswordJuniorRecoveryEmailPlaceholder)
  let recoverButton = WizardButton(title: String.arduinoPasswordJuniorRecoveryButton, style: .solid)
  
  let infoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "sign_in_info_button"), for: .normal)
    button.setContentCompressionResistancePriority(.required, for: .horizontal)
    return button
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoPasswordJuniorRecoveryTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoPasswordJuniorRecoverySubtitle
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
    spacing = 20
    
    addArrangedSubview(titleLabel)
    addArrangedSubview(subtitleLabel)
    
    let usernameStackView = UIStackView()
    usernameStackView.axis = .horizontal
    usernameStackView.spacing = 16
    usernameStackView.addArrangedSubview(UIView())
    usernameStackView.addArrangedSubview(usernameTextField)
    usernameStackView.addArrangedSubview(infoButton)
    addArrangedSubview(usernameStackView)
    
    addArrangedSubview(emailTextField, customSpacing: 28)
    
    let recoverButtonStackView = UIStackView()
    recoverButtonStackView.axis = .horizontal
    recoverButtonStackView.addArrangedSubview(UIView())
    recoverButtonStackView.addArrangedSubview(recoverButton)
    addArrangedSubview(recoverButtonStackView)
    
    NSLayoutConstraint.activate([
      emailTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 260),
      usernameTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
      usernameTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
      recoverButtonStackView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor)
    ])
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

}
