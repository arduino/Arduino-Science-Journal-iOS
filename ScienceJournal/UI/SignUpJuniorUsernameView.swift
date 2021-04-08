//  
//  SignUpJuniorUsernameView.swift
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

class SignUpJuniorUsernameView: UIView {

  let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = " "
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    return label
  }()
  
  let reloadButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "sign_in_reload_button"), for: .normal)
    button.setContentHuggingPriority(.required, for: .horizontal)
    button.setContentCompressionResistancePriority(.required, for: .horizontal)
    return button
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 8
    stackView.layoutMargins = UIEdgeInsets(top: 6, left: 18, bottom: 6, right: 18)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let labelsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 0
    return stackView
  }()
  
  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignInUsernamePlaceholder
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    
    backgroundColor = .white
    layer.cornerRadius = 3
    layer.borderWidth = 1
    layer.borderColor = ArduinoColorPalette.grayPalette.tint200?.cgColor
    
    labelsStackView.addArrangedSubview(placeholderLabel)
    labelsStackView.addArrangedSubview(usernameLabel)
    
    stackView.addArrangedSubview(labelsStackView)
    stackView.addArrangedSubview(reloadButton)
    
    addSubview(stackView)
    stackView.pinToEdgesOfView(self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
