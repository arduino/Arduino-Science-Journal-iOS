//  
//  SignUpParentViewController.swift
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
import RxCocoa
import RxSwift

class SignUpParentViewController: WizardViewController {

  let accountsManager: ArduinoAccountsManager
  private(set) var viewModel: SignUpViewModel
  
  private(set) lazy var signUpParentView = SignUpParentView(isJunior: viewModel.avatar != nil)
  
  private lazy var disposeBag = DisposeBag()
  
  init(accountsManager: ArduinoAccountsManager, viewModel: SignUpViewModel) {
    self.accountsManager = accountsManager
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    wizardView.contentView = signUpParentView
    
    signUpParentView.submitButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
    
    addObservers()
  }
  
  @objc private func submit(_ sender: UIButton) {
    if viewModel.avatar != nil {
      signUpJunior()
    } else {
      signUpTeen()
    }
  }
  
  private func signUpTeen() {
    guard let email = viewModel.email,
          let username = viewModel.username,
          let password = viewModel.password,
          let parentEmail = signUpParentView.emailTextField.text?.lowercased(), !parentEmail.isEmpty else {
      return
    }
    
    isLoading.onNext(true)
    
    viewModel.parentEmail = parentEmail
    accountsManager.signUp(email: email,
                           username: username,
                           password: password,
                           userMetadata: viewModel.userMetadata) { [weak self] in
      guard let self = self else { return }
      
      self.isLoading.onNext(false)
      
      switch $0 {
      case .failure(let error):
        switch error {
        case .notValid(let json):
          if json["code"] as? String == "unconfirmed_teen" {
            let viewController = SignUpParentConfirmationViewController(parentEmail: parentEmail)
            self.show(viewController, sender: nil)
          } else {
            self.backToSignUp(error: json)
          }
        default:
          break
        }
      case .success(let account):
        if account.emailVerified {
          self.rootViewController?.close(isCancelled: false)
        } else {
          let viewController = SignUpConfirmationViewController(account: account, accountsManager: self.accountsManager)
          self.show(viewController, sender: nil)
        }
      }
    }
  }
  
  private func signUpJunior() {
    guard let username = viewModel.username,
          let password = viewModel.password,
          let parentEmail = signUpParentView.emailTextField.text?.lowercased(), !parentEmail.isEmpty else {
      return
    }
    
    isLoading.onNext(true)
    
    viewModel.parentEmail = parentEmail
    accountsManager.signUpJunior(username: username,
                                 password: password,
                                 userMetadata: viewModel.userMetadata) { [weak self] in
      guard let self = self else { return }
      
      self.isLoading.onNext(false)
      
      switch $0 {
      case .failure(let error):
        switch error {
        case .notValid(let json):
          self.backToSignUp(error: json)
        default:
          break
        }
      case .success:
        let viewController = SignUpParentConfirmationViewController(parentEmail: parentEmail)
        self.show(viewController, sender: nil)
      }
    }
  }
  
  private func addObservers() {
    let email = signUpParentView.emailTextField.rx.text.orEmpty
    let confirmedEmail = signUpParentView.emailConfirmationTextField.rx.text.orEmpty
    
    Observable.combineLatest(email, confirmedEmail, isLoading)
      .map { $0.0.isValidEmail && $0.0 == $0.1 && !$0.2 }
      .bind(to: signUpParentView.submitButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    [signUpParentView.emailTextField,
     signUpParentView.emailConfirmationTextField].forEach { control in
      
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
