//  
//  URLRequest+ScienceJournal.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 01/04/21.
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

extension URLRequest {
  static func post(scheme: String = "https",
                   host: String,
                   path: String,
                   data: [String: String?]) -> URLRequest? {
    
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = host
    urlComponents.path = path
    
    guard let requestURL = urlComponents.url else {
      return nil
    }
    
    var request = URLRequest(url: requestURL)
    
    var queryItems = [URLQueryItem]()
    for (key, value) in data {
      queryItems.append(URLQueryItem(name: key, value: value))
    }
    
    urlComponents.queryItems = queryItems
    
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    if let httpBody = urlComponents.query?.data(using: .utf8) {
      request.httpBody = httpBody
      request.addValue("\(httpBody.count)", forHTTPHeaderField: "Content-Length")
    }
    
    return request
  }
}
