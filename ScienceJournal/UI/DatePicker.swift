//  
//  DatePicker.swift
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

class DatePicker: UIDatePicker {

  private let action: (Date) -> Void
  
  init(action: @escaping (Date) -> Void) {
    self.action = action
    
    super.init(frame: .zero)
    
    datePickerMode = .date
    if #available(iOS 13.4, *) {
        preferredDatePickerStyle = .wheels
    }
    maximumDate = Date()
    addTarget(self, action: #selector(updateDate(_:)), for: .valueChanged)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  private func updateDate(_ sender: UIDatePicker) {
      action(date)
  }
}
