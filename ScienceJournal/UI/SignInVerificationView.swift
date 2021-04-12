//  
//  SignInVerificationView.swift
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

class SignInVerificationView: UIStackView {
  
  let codeTextField = WizardTextField(placeholder: String.arduinoSignIn2faPlaceholder)
  let submitButton = WizardButton(title: String.arduinoSignIn2faSubmit, style: .solid)
  
  var error: String? {
    didSet {
      codeErrorView.errorLabel.text = error
      codeErrorView.alpha = (error == nil ? 0 : 1)
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignIn2faTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignIn2faSubtitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignIn2faDescription
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let codeErrorView = SignInErrorView()
  
  init() {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    spacing = 20
    
    addArrangedSubview(titleLabel, customSpacing: 12)
    addArrangedSubview(subtitleLabel)
    addArrangedSubview(descriptionLabel, customSpacing: 20)
    addArrangedSubview(codeTextField, customSpacing: 4)
    
    codeErrorView.alpha = 0
    addArrangedSubview(codeErrorView, customSpacing: 28)
    
    let recoverButtonStackView = UIStackView()
    recoverButtonStackView.axis = .horizontal
    recoverButtonStackView.addArrangedSubview(UIView())
    recoverButtonStackView.addArrangedSubview(submitButton)
    addArrangedSubview(recoverButtonStackView)
    
    NSLayoutConstraint.activate([
      codeTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),
      codeErrorView.widthAnchor.constraint(equalTo: codeTextField.widthAnchor, constant: -4),
      recoverButtonStackView.widthAnchor.constraint(equalTo: codeTextField.widthAnchor)
    ])
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}
