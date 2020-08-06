//  
//  ArduinoColors.swift
//  ScienceJournal
//
//  Created by Sebastian Hunkeler on 06.08.20.
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

let PaletteTint50Name = "50"
let PaletteTint100Name = "100"
let PaletteTint200Name = "200"
let PaletteTint300Name = "300"
let PaletteTint400Name = "400"
let PaletteTint500Name = "500"
let PaletteTint600Name = "600"
let PaletteTint700Name = "700"
let PaletteTint800Name = "800"
let PaletteTint900Name = "900"

let PaletteAccent100Name = "A100"
let PaletteAccent200Name = "A200"
let PaletteAccent400Name = "A300"
let PaletteAccent700Name = "A400"

class ArduinoColors {
  private var tints: [String : UIColor]
  private var accents: [String : UIColor]?

  init(withTints tints: [String : UIColor], accents: [String : UIColor]?) {
    self.tints = tints
    self.accents = accents
  }

  public static func goldPalette() -> ArduinoColors {
    return ArduinoColors(withTints: [
      PaletteTint500Name: UIColor(red: 188/255.0, green: 172/255.0, blue: 153/255.0, alpha: 1)],
                         accents: nil)
  }

  public static func grayPalette() -> ArduinoColors {
    return ArduinoColors(withTints: [
      PaletteTint500Name: UIColor(red: 78/255.0, green: 91/255.0, blue: 97/255.0, alpha: 1)],
                         accents: nil)
  }

  func tint50() -> UIColor? {
      return tints[PaletteTint50Name]
  }

  func tint100() -> UIColor? {
      return tints[PaletteTint100Name]
  }

  func tint200() -> UIColor? {
      return tints[PaletteTint200Name]
  }

  func tint300() -> UIColor? {
      return tints[PaletteTint300Name]
  }

  func tint400() -> UIColor? {
      return tints[PaletteTint400Name]
  }

  func tint500() -> UIColor? {
      return tints[PaletteTint500Name]
  }

  func tint600() -> UIColor? {
      return tints[PaletteTint600Name]
  }

  func tint700() -> UIColor? {
      return tints[PaletteTint700Name]
  }

  func tint800() -> UIColor? {
      return tints[PaletteTint800Name]
  }

  func tint900() -> UIColor? {
      return tints[PaletteTint900Name]
  }

  func accent100() -> UIColor? {
      return accents?[PaletteAccent100Name]
  }

  func accent200() -> UIColor? {
      return accents?[PaletteAccent200Name]
  }

  func accent400() -> UIColor? {
      return accents?[PaletteAccent400Name]
  }

  func accent700() -> UIColor? {
      return accents?[PaletteAccent700Name]
  }

}
