//  
//  GoogleDriveButton.swift
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

class GoogleDriveButton: UIButton {

  convenience init() {
    self.init(type: .system)
    
    let backgroundColor = ArduinoColorPalette.tealPalette.tint800 ?? .black
    
    tintColor = .white
    titleLabel?.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Medium.rawValue)
    setTitle(String.driveSyncIntroGoogleAction, for: .normal)
    setImage(UIImage(named: "google_drive")?.withRenderingMode(.alwaysTemplate), for: .normal)

    let border = UIImage.fill(color: backgroundColor,
                              size: CGSize(width: 51, height: 50),
                              cornerRadius: 25)?
      .resizableImage(withCapInsets: UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25))
    
    let disabledBorder = UIImage.fill(color: backgroundColor.withAlphaComponent(0.4),
                                      size: CGSize(width: 51, height: 50),
                                      cornerRadius: 25)?
      .resizableImage(withCapInsets: UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25))

    setBackgroundImage(border, for: .normal)
    setBackgroundImage(disabledBorder, for: .disabled)

    titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 50)
  }

  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    size.height = 50
    return size
  }
}
