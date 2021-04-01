//  
//  ArduinoAccount.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 30/03/21.
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
import googlemac_iPhone_Shared_SSOAuth_SSOAuth
import GTMSessionFetcher

class ArduinoAccount: AuthAccount, Codable {
  var type: AuthAccountType
  var ID: String
  var email: String
  var displayName: String
  var profileImage: URL?
  var isShareRestricted: Bool
  var authorization: GTMFetcherAuthorizationProtocol?
  
  init(type: AuthAccountType,
       ID: String,
       email: String,
       displayName: String,
       profileImage: URL?,
       isShareRestricted: Bool,
       authorization: GTMFetcherAuthorizationProtocol?) {
  
    self.type = type
    self.ID = ID
    self.email = email
    self.displayName = displayName
    self.profileImage = profileImage
    self.isShareRestricted = isShareRestricted
    self.authorization = authorization
  }
  
  convenience init?(jwt: JWT, type: AuthAccountType) {
    guard let ID = jwt.payload["http://arduino.cc/id"] as? String else {
      return nil
    }
    
    guard let email = jwt.payload["email"] as? String else {
      return nil
    }
    
    guard let displayName = jwt.payload["nickname"] as? String else {
      return nil
    }
    
    let profileImage: URL?
    if let picture = jwt.payload["picture"] as? String {
      profileImage = URL(string: picture)
    } else {
      profileImage = nil
    }
    
    self.init(type: type,
              ID: ID,
              email: email,
              displayName: displayName,
              profileImage: profileImage,
              isShareRestricted: false,
              authorization: nil)
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case ID
    case email
    case displayName
    case profileImage
    case isShareRestricted
  }
}
