//  
//  SignUpView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 24/03/21.
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

class SignUpView: UIStackView {
  
  let emailTextField = WizardTextField(placeholder: String.arduinoSignUpEmailPlaceholder, isRequired: true)
  let usernameTextField = WizardTextField(placeholder: String.arduinoSignUpUsernamePlaceholder, isRequired: true)
  let passwordTextField = WizardTextField(placeholder: String.arduinoSignUpPasswordPlaceholder, isRequired: true)
  let submitButton = WizardButton(title: String.arduinoSignUpSubmitButton, isSolid: true)
  
  let infoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "sign_in_info_button"), for: .normal)
    return button
  }()
  
  private(set) lazy var socialView = SignInSocialView()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignUpTitle
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
  
  private lazy var socialHintLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignInSsoHint
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
    label.numberOfLines = 0
    return label
  }()

  init(hasSingleSignOn: Bool) {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    spacing = 16
    
    addArrangedSubview(titleLabel, customSpacing: 32)
    addArrangedSubview(emailTextField)
    
    let usernameStackView = UIStackView()
    usernameStackView.axis = .horizontal
    usernameStackView.spacing = 16
    usernameStackView.addArrangedSubview(UIView())
    usernameStackView.addArrangedSubview(usernameTextField)
    usernameStackView.addArrangedSubview(infoButton)
    addArrangedSubview(usernameStackView)
    
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
      emailTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 260),
      usernameTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
      usernameTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
      passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
      passwordHintLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
      submitButtonStackView.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
    ])
    
    if hasSingleSignOn {
      let separatorView = SeparatorView(direction: .horizontal, style: .dark)
      addArrangedSubview(separatorView, customSpacing: 12)
      addArrangedSubview(socialHintLabel, customSpacing: 20)
      addArrangedSubview(socialView)
      
      NSLayoutConstraint.activate([
        separatorView.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor)
      ])
    }
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}
