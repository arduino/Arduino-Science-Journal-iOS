//  
//  OnboardingButton.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 17/11/20.
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

class OnboardingButton: UIButton {
  enum Style {
    case outline
    case filled
  }

  enum Size {
    case small
    case large
  }

  private var style = Style.outline
  private var size = Size.small

  convenience init(style: Style, size: Size = .small, title: String) {
    self.init(type: .system)

    self.size = size
    self.style = style

    let verticalSpacing:CGFloat = self.size == .small ? 4 : 8
    contentEdgeInsets = UIEdgeInsets(top: verticalSpacing,
                                     left: 28,
                                     bottom: verticalSpacing,
                                     right: 28)
    setTitle(title, for: .normal)

    let fontSize = self.size == .small ?
      ArduinoTypography.FontSize.XSmall :
      ArduinoTypography.FontSize.Small
    titleLabel?.font = ArduinoTypography.boldFont(forSize: fontSize.rawValue)

    updateStyle()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2.0
  }

  private func updateStyle() {
    switch style {
    case .outline:
      setTitleColor(ArduinoColorPalette.grayPalette.tint700, for: .normal)
      backgroundColor = .clear
      layer.borderWidth = 1.5
      layer.borderColor = ArduinoColorPalette.grayPalette.tint700?.cgColor
    case .filled:
      setTitleColor(.white, for: .normal)
      backgroundColor = ArduinoColorPalette.tealPalette.tint800
      layer.borderWidth = 0
      layer.borderColor = nil
    }
  }
}
