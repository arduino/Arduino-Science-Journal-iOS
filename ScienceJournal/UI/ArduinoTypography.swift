//  
//  ArduinoTypography.swift
//  ScienceJournal
//
//  Created by Sebastian Hunkeler on 20.08.20.
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

import Foundation
import UIKit

class ArduinoTypography {
  
  public static func regularFont(forSize size:CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "OpenSans", size: size) else {
        fatalError("""
            Failed to load the "CustomFont-Light" font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
        )
    }
    return UIFontMetrics.default.scaledFont(for: customFont)
  }
  
  public static func boldFont(forSize size:CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "OpenSans-Bold", size: size) else {
        fatalError("""
            Failed to load the "CustomFont-Light" font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
        )
    }
    return UIFontMetrics.default.scaledFont(for: customFont)
  }
  
}
