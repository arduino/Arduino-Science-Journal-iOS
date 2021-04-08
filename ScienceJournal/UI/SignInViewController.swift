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
import RxCocoa
import RxSwift

class SignInViewController: WizardViewController {

  let accountsManager: ArduinoAccountsManager
  let isAdult: Bool
  
  private(set) lazy var signInView = SignInView(isAdult: isAdult)

  private lazy var disposeBag = DisposeBag()
  
  init(accountsManager: ArduinoAccountsManager, isAdult: Bool) {
    self.accountsManager = accountsManager
    self.isAdult = isAdult
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
    signInView.signInButton.addTarget(self,
                                      action: #selector(signIn(_:)),
                                      for: .touchUpInside)
    
    signInView.socialView.githubButton.addTarget(self, action: #selector(signInWithGitHub(_:)), for: .touchUpInside)
    signInView.socialView.googleButton.addTarget(self, action: #selector(signInWithGoogle(_:)), for: .touchUpInside)
    signInView.socialView.appleButton.addTarget(self, action: #selector(signInWithApple(_:)), for: .touchUpInside)
    
    addObservers()
  }
  
  @objc private func recoverPassword(_ sender: UIButton) {
    if isAdult {
      let viewController = PasswordRecoveryViewController(accountsManager: accountsManager) { [weak self] in
        guard let self = self else { return }
        self.navigationController?.popToViewController(self, animated: true)
      }
      show(viewController, sender: nil)
    } else {
      let viewController = JuniorRecoveryViewController(accountsManager: accountsManager) { [weak self] in
        guard let self = self else { return }
        self.navigationController?.popToViewController(self, animated: true)
      }
      show(viewController, sender: nil)
    }
  }
  
  @objc private func signIn(_ sender: UIButton) {
    guard let username = signInView.usernameTextField.text, !username.isEmpty,
          let password = signInView.passwordTextField.text, !password.isEmpty else {
      return
    }
    
    signInView.error = nil
    isLoading.onNext(true)
    
    if isAdult {
      accountsManager.signIn(username: username,
                             password: password,
                             accountType: .adult,
                             completion: completeWithResult)
    } else {
      accountsManager.signIn(username: username,
                             password: password,
                             accountType: .kid,
                             completion: completeWithResult)
    }
  }

  @objc private func signInWithGitHub(_ sender: UIButton) {
    isLoading.onNext(true)
    accountsManager.signIn(with: .github, from: self, completion: completeWithResult)
  }
  
  @objc private func signInWithGoogle(_ sender: UIButton) {
    isLoading.onNext(true)
    accountsManager.signIn(with: .google, from: self, completion: completeWithResult)
  }
  
  @objc private func signInWithApple(_ sender: UIButton) {
    isLoading.onNext(true)
    accountsManager.signIn(with: .apple, from: self, completion: completeWithResult)
  }
  
  private func presentTwoFactorAuthentication(with token: String) {
    let vc = SignInVerificationViewController(token: token, accountsManager: accountsManager)
    show(vc, sender: nil)
  }
  
  private func completeWithResult(_ result: Result<ArduinoAccount, SignInError>) {
    isLoading.onNext(false)
    switch result {
    case .success: rootViewController?.close(isCancelled: false)
    case .failure(let error):
      if case .notValid(let json) = error, json["error"] as? String == "mfa_required" {
        // 2FA required
        if let token = json["mfa_token"] as? String {
          presentTwoFactorAuthentication(with: token)
        }
      } else {
        signInView.error = String.arduinoSignInErrorMessage
      }
    }
  }
  
  private func addObservers() {
    let hasUsername = signInView.usernameTextField.rx.text.orEmpty
      .map { $0.isValidUsername }
    
    let hasEmail = signInView.usernameTextField.rx.text.orEmpty
      .map { $0.isValidEmail }
    
    let hasPassword = signInView.passwordTextField.rx.text.orEmpty
      .map { $0.isValidPassword }
    
    Observable.combineLatest(hasUsername, hasEmail, hasPassword, isLoading)
      .map { ($0.0 || $0.1) && $0.2 && !$0.3}
      .bind(to: signInView.signInButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    [signInView.usernameTextField,
     signInView.passwordTextField,
     signInView.socialView.githubButton,
     signInView.socialView.googleButton,
     signInView.socialView.appleButton].forEach { control in
      
      isLoading
        .map { !$0 }
        .observe(on: MainScheduler.instance)
        .bind(to: control.rx.isEnabled)
        .disposed(by: disposeBag)
     }
    
    isLoading
      .filter { $0 }
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.view.endEditing(true)
      })
      .disposed(by: disposeBag)
  }
}
