//  
//  PasswordRecoveryConfirmationViewController.swift
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

class PasswordRecoveryConfirmationViewController: WizardViewController {

  let email: String
  let authenticationManager: AuthenticationManager
  let completion: () -> Void
  
  private(set) lazy var confirmationView = PasswordRecoveryConfirmationView()

  init(email: String,
       authenticationManager: AuthenticationManager,
       completion: @escaping () -> Void) {
    self.email = email
    self.authenticationManager = authenticationManager
    self.completion = completion
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    wizardView.contentView = confirmationView
    
    confirmationView.backButton.addTarget(self,
                                          action: #selector(back(_:)),
                                          for: .touchUpInside)
  }
  
  @objc private func back(_ sender: UIButton) {
    completion()
  }
}
