//  
//  SignInIntroView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 22/03/21.
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

class SignInIntroView: UIStackView {
  
  let juniorButton = WizardButton(title: String.arduinoSignInJuniorButton,
                                  isSolid: true,
                                  size: .big)
  
  let adultButton = WizardButton(title: String.arduinoSignInRegularButton,
                                 isSolid: true,
                                 size: .big)
  
  let registrationLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
    label.numberOfLines = 0
    label.isUserInteractionEnabled = true
    
    let attributedText = NSMutableAttributedString(string: "\(String.arduinoSignInRegistrationHint) ")
    let cta = NSAttributedString(string: String.arduinoSignInRegistrationCta, attributes: [
      NSAttributedString.Key.font: ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue),
      NSAttributedString.Key.foregroundColor: ArduinoColorPalette.tealPalette.tint800!,
    ])
    attributedText.append(cta)
    
    label.attributedText = attributedText
    
    return label
  }()
  
  private let logoImageView = UIImageView(image: UIImage(named: "arduino_navigation_title"))
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = String.arduinoSignInIntroTitle
    label.textAlignment = .center
    label.textColor = .black
    label.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Large.rawValue)
    label.numberOfLines = 0
    return label
  }()
  
  private let separatorView = SeparatorView(direction: .horizontal, style: .dark)
  
  init() {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .center
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    spacing = 0
    
    addArrangedSubview(logoImageView, customSpacing: 20)
    addArrangedSubview(titleLabel, customSpacing: 40)
    addArrangedSubview(juniorButton, customSpacing: 30)
    addArrangedSubview(adultButton, customSpacing: 48)
    addArrangedSubview(separatorView, customSpacing: 16)
    addArrangedSubview(registrationLabel)
    
    NSLayoutConstraint.activate([
      juniorButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),
      adultButton.widthAnchor.constraint(equalTo: juniorButton.widthAnchor),
      separatorView.widthAnchor.constraint(equalTo: adultButton.widthAnchor)
    ])
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}
