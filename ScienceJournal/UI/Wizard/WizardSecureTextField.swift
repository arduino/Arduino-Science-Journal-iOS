//  
//  WizardSecureTextField.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 15/04/21.
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

class WizardSecureTextField: WizardTextField {
  
  override var isSecureTextEntry: Bool {
    didSet {
      if isSecureTextEntry {
        toggleButton.setImage(UIImage(named: "sign_in_show_password"), for: .normal)
      } else {
        toggleButton.setImage(UIImage(named: "sign_in_hide_password"), for: .normal)
      }
    }
  }
  
  private lazy var toggleButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(toggle(_:)), for: .touchUpInside)
    return button
  }()
  
  override init(placeholder: String, isRequired: Bool = false) {
    super.init(placeholder: placeholder, isRequired: isRequired)
    
    defer {
      isSecureTextEntry = true
    }
    
    textContentType = .password
    rightView = toggleButton
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(toggleRightView),
                                           name: UITextField.textDidChangeNotification,
                                           object: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func toggle(_ sender: UIButton) {
    isSecureTextEntry.toggle()
  }
  
  @objc private func toggleRightView() {
    if let text = text, !text.isEmpty {
      rightViewMode = .always
    } else {
      rightViewMode = .never
    }
  }
}
