//  
//  SignInIntroViewController.swift
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

class SignInIntroViewController: WizardViewController {

  let authenticationManager: AuthenticationManager

  private(set) lazy var introView = SignInIntroView()

  init(authenticationManager: AuthenticationManager) {
    self.authenticationManager = authenticationManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    introView.juniorButton.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
    introView.regularButton.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
    
    let signUpTap = UITapGestureRecognizer(target: self, action: #selector(signUp(_:)))
    introView.registrationLabel.addGestureRecognizer(signUpTap)
    
    wizardView.contentView = introView
  }

  @objc private func signIn(_ sender: UIButton) {
    let isJunior = sender == introView.juniorButton
    
    let signInViewController = SignInViewController(authenticationManager: authenticationManager,
                                                    isJunior: isJunior)
    show(signInViewController, sender: nil)
  }
  
  @objc private func signUp(_ sender: UITapGestureRecognizer) {
    if sender.state == .ended {
      let signUpViewController = SignUpBirthdateViewController(authenticationManager: authenticationManager)
      show(signUpViewController, sender: nil)
    }
  }
}
