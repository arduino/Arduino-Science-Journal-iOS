//  
//  WizardButton.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 05/01/21.
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

class WizardButton: UIButton {

  private var isSolid = false

  convenience init(title: String? = nil, isSolid: Bool = false) {
    self.init(type: .system)
    self.isSolid = isSolid

    let tealColor = ArduinoColorPalette.tealPalette.tint800!

    if isSolid {
      tintColor = UIColor.white
      let backgroundImage = UIImage.fill(color: tealColor,
                                         size: CGSize(width: 39, height: 38),
                                         cornerRadius: 19)?
        .resizableImage(withCapInsets: UIEdgeInsets(top: 19,
                                                    left: 19,
                                                    bottom: 19,
                                                    right: 19))

      let disabledImage = UIImage.fill(color: tealColor.withAlphaComponent(0.4),
                                       size: CGSize(width: 39, height: 38),
                                       cornerRadius: 19)?
        .resizableImage(withCapInsets: UIEdgeInsets(top: 19,
                                                    left: 19,
                                                    bottom: 19,
                                                    right: 19))

      setBackgroundImage(backgroundImage, for: .normal)
      setBackgroundImage(disabledImage, for: .disabled)
      setTitleColor(UIColor.white, for: .normal)
      setTitleColor(UIColor.white, for: .disabled)
      titleLabel?.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
      contentEdgeInsets = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
    } else {
      tintColor = tealColor
      titleLabel?.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
    }

    setTitle(title, for: .normal)
  }

  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    if isSolid {
      size.height = 38
    }
    return size
  }

}
