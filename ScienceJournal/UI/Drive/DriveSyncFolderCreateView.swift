//  
//  DriveSyncFolderCreateView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 11/01/21.
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
import MaterialComponents

class DriveSyncFolderCreateView: UIStackView {

  let onCreate: (String) -> Void
  
  private let textField = MDCTextField()
  private let createButton = WizardButton(title: String.driveSyncCreateFolderButton, style: .solid)
  
  init(onCreate: @escaping (String) -> Void) {
    self.onCreate = onCreate
    
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    spacing = 25
    
    addArrangedSubview(textField)
    addArrangedSubview(createButton)
    
    textField.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    textField.textColor = ArduinoColorPalette.grayPalette.tint800
    textField.cursorColor = ArduinoColorPalette.tealPalette.tint800
    
    textField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    textField.addTarget(self, action: #selector(refreshButton(_:)), for: .editingChanged)
    
    textField.text = String.driveSyncCreateFolderDefault
    
    createButton.addTarget(self, action: #selector(create(_:)), for: .touchUpInside)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func refreshButton(_ sender: UITextField) {
    if let text = textField.text, !text.isEmpty {
      createButton.isEnabled = true
    } else {
      createButton.isEnabled = false
    }
  }
  
  @objc private func create(_ sender: UIButton) {
    onCreate(textField.text ?? "")
  }
}
