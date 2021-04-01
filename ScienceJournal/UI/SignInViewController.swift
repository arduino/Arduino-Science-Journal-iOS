//  
//  SignInViewController.swift
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

class SignInViewController: WizardViewController {

  let accountsManager: ArduinoAccountsManager
  let isJunior: Bool
  
  private(set) lazy var signInView = SignInView(hasSingleSignOn: !isJunior)

  init(accountsManager: ArduinoAccountsManager, isJunior: Bool) {
    self.accountsManager = accountsManager
    self.isJunior = isJunior
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    wizardView.contentView = signInView
    
    signInView.passwordRecoveryButton.addTarget(self,
                                                action: #selector(recoverPassword(_:)),
                                                for: .touchUpInside)
    
    signInView.socialView.githubButton.addTarget(self, action: #selector(signInWithGitHub(_:)), for: .touchUpInside)
    signInView.socialView.googleButton.addTarget(self, action: #selector(signInWithGoogle(_:)), for: .touchUpInside)
    signInView.socialView.appleButton.addTarget(self, action: #selector(signInWithApple(_:)), for: .touchUpInside)
  }
  
  @objc private func recoverPassword(_ sender: UIButton) {
    let viewController = PasswordRecoveryViewController(accountsManager: accountsManager) { [weak self] in
      guard let self = self else { return }
      self.navigationController?.popToViewController(self, animated: true)
    }
    show(viewController, sender: nil)
  }

  @objc private func signInWithGitHub(_ sender: UIButton) {
    accountsManager.signIn(with: .github, from: self, completion: completeWithResult)
  }
  
  @objc private func signInWithGoogle(_ sender: UIButton) {
    accountsManager.signIn(with: .google, from: self, completion: completeWithResult)
  }
  
  @objc private func signInWithApple(_ sender: UIButton) {
    accountsManager.signIn(with: .apple, from: self, completion: completeWithResult)
  }
  
  private func completeWithResult(_ result: Result<ArduinoAccount, SignInError>) {
    switch result {
    case .success: rootViewController?.close(isCancelled: false)
    case .failure: break
    }
  }
}
