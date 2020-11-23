//  
//  UIResponder+ErrorHandling.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 18/11/20.
//  Copyright © 2020 Arduino. All rights reserved.
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

extension UIResponder {

  @objc func handle(_ error: Error,
                    from viewController: UIViewController? = UIApplication.shared.topViewController) {

    guard let nextResponder = next else {
      return assertionFailure("""
            Unhandled error \(error) from \(String(describing: viewController))
            """)
    }

    nextResponder.handle(error, from: viewController)
  }
}
