//  
//  SignInErrorView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 06/04/21.
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

class SignInErrorView: UIStackView {
  let errorLabel = UILabel()
  
  init() {
    super.init(frame: .zero)

    axis = .horizontal
    alignment = .center
    spacing = 8
    
    let imageView = UIImageView(image: UIImage(named: "sign_in_error"))
    imageView.contentMode = .scaleAspectFit
    imageView.setContentHuggingPriority(.required, for: .horizontal)
    imageView.setContentHuggingPriority(.required, for: .vertical)
    imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    imageView.setContentCompressionResistancePriority(.required, for: .vertical)
    addArrangedSubview(imageView)
    
    errorLabel.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
    errorLabel.textColor = UIColor(red: 218/255.0, green: 91/255.0, blue: 74/255.0, alpha: 1)
    addArrangedSubview(errorLabel)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
