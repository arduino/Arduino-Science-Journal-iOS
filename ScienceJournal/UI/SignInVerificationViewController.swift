//  
//  SignInVerificationViewController.swift
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
import RxSwift

class SignInVerificationViewController: WizardViewController {

  let token: String
  let accountsManager: ArduinoAccountsManager
  
  private(set) lazy var verificationView = SignInVerificationView()

  private lazy var disposeBag = DisposeBag()
  
  init(token: String, accountsManager: ArduinoAccountsManager) {
    self.token = token
    self.accountsManager = accountsManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    wizardView.contentView = verificationView
    
    verificationView.submitButton.addTarget(self,
                                            action: #selector(verify(_:)),
                                            for: .touchUpInside)
    
    addObservers()
  }
  
  @objc private func verify(_ sender: UIButton) {
    guard let code = verificationView.codeTextField.text, !code.isEmpty else {
      return
    }
    
    verificationView.error = nil
    isLoading.onNext(true)
    
    accountsManager.verify(code: code, token: token) { [weak self] in
      self?.isLoading.onNext(false)
      switch $0 {
      case .success: self?.rootViewController?.close(isCancelled: false)
      case .failure: self?.verificationView.error = String.arduinoSignIn2faError
      }
    }
  }
  
  private func addObservers() {
    let hasCode = verificationView.codeTextField.rx.text.orEmpty
      .map { !$0.isEmpty }
    
    Observable.combineLatest( hasCode, isLoading)
      .map { $0.0 && !$0.1}
      .bind(to: verificationView.submitButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    [verificationView.codeTextField].forEach { control in
      
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
