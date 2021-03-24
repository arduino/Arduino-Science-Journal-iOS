//  
//  KeyboardDismissToolbar.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 24/03/21.
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

class KeyboardDismissToolbar: UIToolbar {
  
  private var done: (() -> Void)?
  
  init(done: @escaping () -> Void) {
    super.init(frame: .zero)
    
    self.done = done
    
    barStyle = .default
    isTranslucent = true
    tintColor = ArduinoColorPalette.tealPalette.tint800
    
    let spacer: UIBarButtonItem
    if #available(iOS 14.0, *) {
      spacer = UIBarButtonItem.flexibleSpace()
    } else {
      spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:)))
    
    setItems([
      spacer,
      done
    ], animated: false)
    
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  @objc private func done(_ sender: UIBarButtonItem) {
    guard let done = self.done else { return }
    done()
  }
}
