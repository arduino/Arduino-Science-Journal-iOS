//  
//  SignUpBirthdateView.swift
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

class SignUpBirthdateView: UIStackView {

  let submitButton = WizardButton(title: String.arduinoSignUpBirthdateSubmit, isSolid: true)
  
  let infoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "sign_in_info_button"), for: .normal)
    return button
  }()
  
  private(set) var birthdate: Date? {
    didSet {
      reloadBirthdateTextField()
    }
  }
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignUpTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignUpBirthdateSubtitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private lazy var birthdateTextField: WizardTextField = {
    let textField = WizardTextField(placeholder: String.arduinoSignUpBirthdatePlaceholder, isRequired: true)
    textField.delegate = self
    textField.inputView = DatePicker { [weak self] date in
      self?.birthdate = date
    }
    textField.inputAccessoryView = KeyboardDismissToolbar { [weak self] in
      self?.birthdateTextField.resignFirstResponder()
    }
    return textField
  }()
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .medium
    return formatter
  }()

  init() {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    spacing = 20
    
    addArrangedSubview(titleLabel)
    addArrangedSubview(subtitleLabel)
    
    let textFieldStackView = UIStackView()
    textFieldStackView.axis = .horizontal
    textFieldStackView.spacing = 16
    textFieldStackView.addArrangedSubview(UIView())
    textFieldStackView.addArrangedSubview(birthdateTextField)
    textFieldStackView.addArrangedSubview(infoButton)
    addArrangedSubview(textFieldStackView, customSpacing: 36)
    
    let submitButtonStackView = UIStackView()
    submitButtonStackView.axis = .horizontal
    submitButtonStackView.addArrangedSubview(UIView())
    submitButtonStackView.addArrangedSubview(submitButton)
    addArrangedSubview(submitButtonStackView)
    
    NSLayoutConstraint.activate([
      birthdateTextField.widthAnchor.constraint(equalToConstant: 210),
      birthdateTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
      submitButton.trailingAnchor.constraint(equalTo: birthdateTextField.trailingAnchor)
    ])
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func reloadBirthdateTextField() {
    if let date = birthdate {
      birthdateTextField.text = dateFormatter.string(from: date)
    } else {
      birthdateTextField.text = nil
    }
  }
}

extension SignUpBirthdateView: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    false
  }
}
