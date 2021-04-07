//  
//  WizardTextField.swift
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

class WizardTextField: UITextField {
  
  var isRequired: Bool = false {
    didSet {
      refreshPlaceholder()
    }
  }
  
  var hasError: Bool = false {
    didSet {
      refreshBorder()
    }
  }
  
  override var placeholder: String? {
    didSet {
      _placeholder = placeholder
      refreshPlaceholder()
    }
  }
  
  private var placeholderFont: UIFont? {
    return font
  }
  
  var errorColor: UIColor? {
    requiredColor
  }
  
  private var requiredColor: UIColor? {
    UIColor(red: 218/255.0, green: 91/255.0, blue: 74/255.0, alpha: 1)
  }
  
  private var _placeholder: String?
  
  init(placeholder: String, isRequired: Bool = false) {
    super.init(frame: .zero)
    
    self.backgroundColor = .white
    self.font = ArduinoTypography.headingFont
    self.tintColor = ArduinoColorPalette.tealPalette.tint700
    
    self.layer.cornerRadius = 3
    self.layer.borderWidth = 1
    
    setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .horizontal)
    
    self.isRequired = isRequired
    self.placeholder = placeholder
    
    refreshBorder()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    size.height = 58
    return size
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    let rect = super.textRect(forBounds: bounds)
    return rect.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    textRect(forBounds: bounds)
  }
  
  private func refreshPlaceholder() {
    guard let text = _placeholder else {
      self.attributedPlaceholder = nil
      return
    }
    
    var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black]
    
    if let font = placeholderFont {
      attributes[NSAttributedString.Key.font] = font
    }
    
    let attributedPlaceholder = NSMutableAttributedString(string: text,
                                                          attributes: attributes)
    
    if isRequired {
      attributes[NSAttributedString.Key.foregroundColor] = requiredColor
      attributedPlaceholder.append(NSAttributedString(string: " *", attributes: attributes))
    }
    
    self.attributedPlaceholder = attributedPlaceholder
  }
  
  private func refreshBorder() {
    if hasError {
      self.layer.borderColor = errorColor?.cgColor
    } else {
      self.layer.borderColor = ArduinoColorPalette.grayPalette.tint200?.cgColor
    }
  }
}
