//  
//  SignUpTermsViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 29/03/21.
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

enum SignUpTermsItem: CaseIterable, Hashable {
  case termsAndPrivacy
  case newsletter
  case marketing
  case tracking
  
  var htmlText: String {
    switch self {
    case .termsAndPrivacy: return String.arduinoSignUpTermsAndPrivacy
    case .newsletter: return String.arduinoSignUpNewsletterApproval
    case .marketing: return String.arduinoSignUpMarketingApproval
    case .tracking: return String.arduinoSignUpTrackingApproval
    }
  }
  
  var isRequired: Bool {
    switch self {
    case .termsAndPrivacy: return true
    default: return false
    }
  }
  
  var urls: [URL] {
    switch self {
    case .termsAndPrivacy: return []
    default: return []
    }
  }
}

class SignUpTermsViewController: WizardViewController {
  
  let authenticationManager: AuthenticationManager
  
  private(set) lazy var termsView = SignUpTermsView(terms: SignUpTermsItem.allCases)
  
  init(authenticationManager: AuthenticationManager) {
    self.authenticationManager = authenticationManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    wizardView.contentView = termsView
  }
}
