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
  
  public enum FontSize : CGFloat {
    case XXSmall = 12.0
    case XSmall = 14.0
    case Small = 16.0
    case Medium = 20.0
    case MediumLarge = 24.0
    case Large = 28.0
    case XLarge = 36.0
    case XXLarge = 48.0
  }
  
  public static let emptyViewTitleOpacity: CGFloat = 0.3
  public static let titleFont = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
  public static let subtitleFont = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
  public static let flatButtonFont = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
  public static let headingFont = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Medium.rawValue)
  public static let paragraphFont = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
  public static let badgeFont = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
  public static let labelFont = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
  public static let sensorValueFont = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.MediumLarge.rawValue)
  
  public static func regularFont(forSize size:CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "OpenSans", size: size) else {
        fatalError("""
            Failed to load the "OpenSans" font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
        )
    }
    return UIFontMetrics.default.scaledFont(for: customFont)
  }
  
  public static func boldFont(forSize size:CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "OpenSans-Bold", size: size) else {
        fatalError("""
            Failed to load the "OpenSans-Bold" font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
        )
    }
    return UIFontMetrics.default.scaledFont(for: customFont)
  }

  public static func monoRegularFont(forSize size:CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "RobotoMono-Regular", size: size) else {
      fatalError("""
            Failed to load the "RobotoMono-Regular" font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
      )
    }
    return UIFontMetrics.default.scaledFont(for: customFont)
  }

  public static func monoBoldFont(forSize size:CGFloat) -> UIFont {
    guard let customFont = UIFont(name: "RobotoMono-Bold", size: size) else {
      fatalError("""
            Failed to load the "RobotoMono-Bold" font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
      )
    }
    return UIFontMetrics.default.scaledFont(for: customFont)
  }
  
}
