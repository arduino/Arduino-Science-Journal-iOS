//  
//  SignUpJuniorView.swift
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

class SignUpJuniorView: UIStackView {

  let avatarView = SignUpJuniorAvatarView()
  let usernameView = SignUpJuniorUsernameView()
  
  let infoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "sign_in_info_button"), for: .normal)
    return button
  }()
  
  let passwordTextField = WizardSecureTextField(placeholder: String.arduinoSignUpPasswordPlaceholder, isRequired: true)
  let submitButton = WizardButton(title: String.arduinoSignUpSubmitButton, style: .solid)
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignUpJuniorTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var passwordHintLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignUpPasswordHint
    label.textAlignment = .left
    label.textColor = ArduinoColorPalette.grayPalette.tint400
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
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
    
    addArrangedSubview(avatarView)
    
    let usernameStackView = UIStackView()
    usernameStackView.axis = .horizontal
    usernameStackView.spacing = 16
    usernameStackView.addArrangedSubview(UIView())
    usernameStackView.addArrangedSubview(usernameView)
    usernameStackView.addArrangedSubview(infoButton)
    addArrangedSubview(usernameStackView, customSpacing: 25)
    
    addArrangedSubview(passwordTextField, customSpacing: 2)
    
    let passwordHintStackView = UIStackView()
    passwordHintStackView.axis = .horizontal
    passwordHintStackView.addArrangedSubview(passwordHintLabel)
    passwordHintStackView.addArrangedSubview(UIView())
    addArrangedSubview(passwordHintStackView)
    
    let submitButtonStackView = UIStackView()
    submitButtonStackView.axis = .horizontal
    submitButtonStackView.addArrangedSubview(UIView())
    submitButtonStackView.addArrangedSubview(submitButton, customSpacing: 28)
    addArrangedSubview(submitButtonStackView)
    
    NSLayoutConstraint.activate([
      avatarView.widthAnchor.constraint(equalToConstant: 80),
      avatarView.heightAnchor.constraint(equalToConstant: 80),
      passwordTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 260),
      usernameView.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
      usernameView.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
      usernameView.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor),
      passwordHintLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
      submitButtonStackView.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
    ])
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

}
