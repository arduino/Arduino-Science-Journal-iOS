//  
//  SignInSocialView.swift
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

class SignInSocialView: UIStackView {

  let githubButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "sign_in_with_github"), for: .normal)
    return button
  }()
  
  let googleButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "sign_in_with_google"), for: .normal)
    return button
  }()
  
  let appleButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "sign_in_with_apple"), for: .normal)
    return button
  }()
  
  init() {
    super.init(frame: .zero)

    axis = .horizontal
    distribution = .equalCentering
    spacing = 20
    
    addArrangedSubview(githubButton)
    addArrangedSubview(googleButton)
    addArrangedSubview(appleButton)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
