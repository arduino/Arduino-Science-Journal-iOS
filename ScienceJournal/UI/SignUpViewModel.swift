//  
//  SignUpViewModel.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 06/04/21.
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

import Foundation

struct SignUpViewModel {
  var birthdate: Date
  var email: String?
  var username: String?
  var password: String?
  var acceptedTerms = [SignUpTermsItem]()
  var parentEmail: String?
  
  var age: Int {
    let now = Date()
    let ageComponents = Calendar.autoupdatingCurrent.dateComponents([.year], from: birthdate, to: now)
    return ageComponents.year ?? 0
  }
  
  var isAdult: Bool {
    let now = Date()
    let ageComponents = Calendar.autoupdatingCurrent.dateComponents([.year], from: birthdate, to: now)
    guard let age = ageComponents.year else { return false }
    return age >= 16
  }
  
  var userMetadata: [String: String] {
    var userMetadata = [String: String]()
    
    for termsItem in acceptedTerms {
      switch termsItem {
      case .termsAndPrivacy:
        userMetadata["privacy_approval"] = "true"
        userMetadata["terms_and_conditions"] = "true"
      case .marketing:
        userMetadata["marketing_approval"] = "true"
      case .newsletter:
        userMetadata["newsletter_approval"] = "true"
      case .tracking:
        userMetadata["tracking_approval"] = "true"
      }
    }
    
    if let parentEmail = parentEmail {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      
      userMetadata["parent_email"] = parentEmail
      userMetadata["birthday"] = dateFormatter.string(from: birthdate)
    }
    
    return userMetadata
  }
  
  var hasAcceptedRequiredTerms: Bool {
    let allRequired = SignUpTermsItem.allCases.filter { $0.isRequired }
    var result = true
    allRequired.forEach {
      if !acceptedTerms.contains($0) {
        result = false
      }
    }
    return result
  }
  
  init(birthdate: Date) {
    self.birthdate = birthdate
  }
}

extension String {
  var isValidEmail: Bool {
    return !isEmpty &&
      range(of: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#,
            options: .regularExpression) != nil
  }
  
  var isValidUsername: Bool {
    return !isEmpty &&
      range(of: #"^[A-Z0-9a-z]+[A-Za-z0-9_-]{2,}$"#,
            options: .regularExpression) != nil
  }
  
  var isValidPassword: Bool {
    return count >= 8
  }
}
