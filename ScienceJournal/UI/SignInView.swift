//  
//  SignInView.swift
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

class SignInView: UIStackView {

  let usernameTextField = WizardTextField(placeholder: String.arduinoSignInUsernamePlaceholder)
  let passwordTextField = WizardTextField(placeholder: String.arduinoSignInPasswordPlaceholder)
  let passwordRecoveryButton = WizardButton(title: String.arduinoSignInPasswordRecoveryButton, isSolid: false)
  let signInButton = WizardButton(title: String.arduinoSignInButton, isSolid: true)
  
  private(set) lazy var socialView = SignInSocialView()
  
  private let logoImageView = UIImageView(image: UIImage(named: "arduino_navigation_title"))
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignInIntroTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    return label
  }()
  
  private lazy var socialHintLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignInSsoHint
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
    return label
  }()

  init(hasSingleSignOn: Bool) {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    spacing = 0
    
    addArrangedSubview(logoImageView, customSpacing: 20)
    addArrangedSubview(titleLabel, customSpacing: 20)
    addArrangedSubview(usernameTextField, customSpacing: 28)
    addArrangedSubview(passwordTextField, customSpacing: 8)
    
    let passwordRecoveryStackView = UIStackView()
    passwordRecoveryStackView.axis = .horizontal
    passwordRecoveryStackView.addArrangedSubview(passwordRecoveryButton)
    passwordRecoveryStackView.addArrangedSubview(UIView())
    addArrangedSubview(passwordRecoveryStackView, customSpacing: 8)
    
    let signInButtonStackView = UIStackView()
    signInButtonStackView.axis = .horizontal
    signInButtonStackView.addArrangedSubview(UIView())
    signInButtonStackView.addArrangedSubview(signInButton)
    addArrangedSubview(signInButtonStackView, customSpacing: 28)
    
    NSLayoutConstraint.activate([
      usernameTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),
      passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
      passwordRecoveryStackView.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
      signInButtonStackView.widthAnchor.constraint(equalTo: passwordRecoveryStackView.widthAnchor)
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
