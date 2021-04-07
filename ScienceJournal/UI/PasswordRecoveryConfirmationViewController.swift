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
import RxCocoa
import RxSwift

class PasswordRecoveryConfirmationViewController: WizardViewController {

  let email: String
  let accountsManager: ArduinoAccountsManager
  let completion: () -> Void
  
  private(set) lazy var confirmationView = PasswordRecoveryConfirmationView()

  private lazy var disposeBag = DisposeBag()
  
  init(email: String,
       accountsManager: ArduinoAccountsManager,
       completion: @escaping () -> Void) {
    self.email = email
    self.accountsManager = accountsManager
    self.completion = completion
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    wizardView.contentView = confirmationView
    
    confirmationView.resendButton.addTarget(self,
                                            action: #selector(recoverPassword),
                                            for: .touchUpInside)
    confirmationView.backButton.addTarget(self,
                                          action: #selector(back(_:)),
                                          for: .touchUpInside)
    
    isLoading
      .map { !$0 }
      .bind(to: confirmationView.resendButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    recoverPassword()
  }
  
  @objc private func back(_ sender: UIButton) {
    completion()
  }
  
  @objc private func recoverPassword() {
    isLoading.onNext(true)
    accountsManager.recoverPassword(for: email) { [weak self] _ in
      self?.isLoading.onNext(false)
    }
  }
}
