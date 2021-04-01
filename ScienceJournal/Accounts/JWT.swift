//  
//  JWT.swift
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

struct JWT {
  
  let header: [String: Any]
  let payload: [String: Any]
  
  private let token: String
  
  init?(token: String) {
    let parts = token.split(separator: ".")
    
    guard parts.count == 3 else { return nil }
    guard let headerData = Self.base64decode(input: String(parts[0])) else { return nil }
    guard let payloadData = Self.base64decode(input: String(parts[1])) else { return nil }
    
    do {
      guard let header = try JSONSerialization.jsonObject(with: headerData, options: []) as? [String: Any] else { return nil }
      guard let payload = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else { return nil }
      
      self.header = header
      self.payload = payload
      self.token = token
    } catch {
      return nil
    }
  }
  
  private static func base64decode(input: String) -> Data? {
    let rem = input.count % 4
    
    var ending = ""
    if rem > 0 {
      let amount = 4 - rem
      ending = String(repeating: "=", count: amount)
    }
    
    let base64 = input.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/") + ending
    
    return Data(base64Encoded: base64, options: [.ignoreUnknownCharacters])
  }
}

extension JWT: CustomStringConvertible {
  var description: String { token }
}
