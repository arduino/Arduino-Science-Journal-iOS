//  
//  SignUpParentConfirmationViewController.swift
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

class SignUpParentConfirmationViewController: WizardViewController {

  let parentEmail: String
  
  private(set) lazy var confirmationView = SignUpParentConfirmationView(parentEmail: parentEmail)

  init(parentEmail: String) {
    self.parentEmail = parentEmail
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.hidesBackButton = true
    
    wizardView.contentView = confirmationView
    
    confirmationView.closeButton.addTarget(self,
                                           action: #selector(close(_:)),
                                           for: .touchUpInside)
  }
  
  @objc private func back(_ sender: UIButton) {
    rootViewController?.close(isCancelled: true)
  }
  
}
