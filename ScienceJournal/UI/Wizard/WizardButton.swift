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
  
  enum Style {
    case system
    case solid
    case outlined
  }
  
  enum Size {
    case regular
    case big
    
    fileprivate var height: CGFloat {
      switch self {
      case .big: return 50
      case .regular: return 38
      }
    }
    
    fileprivate var inset: CGFloat {
      switch self {
      case .big: return 36
      case .regular: return 28
      }
    }
  }

  private var style = Style.system
  private var size = Size.regular
  
  convenience init(title: String? = nil, style: Style = .system, size: Size = .regular) {
    self.init(type: .system)
    self.style = style
    self.size = size
    
    let tealColor = ArduinoColorPalette.tealPalette.tint800!
    
    let height = size.height
    let inset = size.inset
    
    switch style {
    case .system:
      tintColor = tealColor
      titleLabel?.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
      
    case .solid:
      tintColor = UIColor.white
      let backgroundImage = UIImage.fill(color: tealColor,
                                         size: CGSize(width: height+1, height: height),
                                         cornerRadius: height/2)?
        .resizableImage(withCapInsets: UIEdgeInsets(top: height/2,
                                                    left: height/2,
                                                    bottom: height/2,
                                                    right: height/2))

      let disabledImage = UIImage.fill(color: tealColor.withAlphaComponent(0.4),
                                       size: CGSize(width: height+1, height: height),
                                       cornerRadius: height/2)?
        .resizableImage(withCapInsets: UIEdgeInsets(top: height/2,
                                                    left: height/2,
                                                    bottom: height/2,
                                                    right: height/2))

      setBackgroundImage(backgroundImage, for: .normal)
      setBackgroundImage(disabledImage, for: .disabled)
      setTitleColor(UIColor.white, for: .normal)
      setTitleColor(UIColor.white, for: .disabled)
      titleLabel?.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
      contentEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    
    case .outlined:
      tintColor = tealColor
      let backgroundImage = UIImage.stroke(color: tealColor,
                                           size: CGSize(width: height+1, height: height),
                                           cornerRadius: height/2)?
        .resizableImage(withCapInsets: UIEdgeInsets(top: height/2,
                                                    left: height/2,
                                                    bottom: height/2,
                                                    right: height/2))
      
      let disabledImage = UIImage.stroke(color: tealColor.withAlphaComponent(0.4),
                                         size: CGSize(width: height+1, height: height),
                                         cornerRadius: height/2)?
        .resizableImage(withCapInsets: UIEdgeInsets(top: height/2,
                                                    left: height/2,
                                                    bottom: height/2,
                                                    right: height/2))

      setBackgroundImage(backgroundImage, for: .normal)
      setBackgroundImage(disabledImage, for: .disabled)
      setTitleColor(tealColor, for: .normal)
      setTitleColor(tealColor.withAlphaComponent(0.4), for: .disabled)
      titleLabel?.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
      contentEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    setTitle(title, for: .normal)
  }

  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    switch style {
    case .solid, .outlined:
      size.height = self.size.height
    default: break
    }
    return size
  }

}
