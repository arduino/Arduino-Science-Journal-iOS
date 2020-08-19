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
      //Light Bronze
      PaletteTint500Name: UIColor(red: 188/255.0, green: 172/255.0, blue: 153/255.0, alpha: 1)],
                         accents: nil)
  }

  public static func tealPalette() -> ArduinoColors {
    return ArduinoColors(withTints: [
      //Teal 6
      PaletteTint100Name: UIColor(red: 165/255.0, green: 242/255.0, blue: 238/255.0, alpha: 1),
      //Teal 0
      PaletteTint200Name: UIColor(red: 127/255.0, green: 203/255.0, blue: 205/255.0, alpha: 1),
      //Teal 1
      PaletteTint300Name: UIColor(red: 12/255.0, green: 161/255.0, blue: 166/255.0, alpha: 1),
      //Teal 2
      PaletteTint400Name: UIColor(red: 0, green: 151/255.0, blue: 157/255.0, alpha: 1),
      //Teal 3
      PaletteTint500Name: UIColor(red: 0, green: 129/255.0, blue: 132/255.0, alpha: 1),
      //Teal 4
      PaletteTint600Name: UIColor(red: 0, green: 109/255.0, blue: 112/255.0, alpha: 1),
      //Teal 5
      PaletteTint700Name: UIColor(red: 0, green: 92/255.0, blue: 95/255.0, alpha: 1)
      ],
                         accents: [PaletteAccent700Name : UIColor.white]
    )
  }

  public static func grayPalette() -> ArduinoColors {
    return ArduinoColors(withTints: [
      //Base Gray
      PaletteTint50Name: UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1),
      //Clouds
      PaletteTint100Name: UIColor(red: 236/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1),
      //Smoke
      PaletteTint200Name: UIColor(red: 201/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1),
      //Concrete
      PaletteTint300Name: UIColor(red: 149/255.0, green: 165/255.0, blue: 166/255.0, alpha: 1),
      //Asbestos
      PaletteTint400Name: UIColor(red: 127/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1),
      //Gris
      PaletteTint500Name: UIColor(red: 78/255.0, green: 91/255.0, blue: 97/255.0, alpha: 1),
      //Dust
      PaletteTint500Name: UIColor(red: 67/255.0, green: 79/255.0, blue: 84/255.0, alpha: 1),
      //Jet
      PaletteTint700Name: UIColor(red: 55/255.0, green: 65/255.0, blue: 70/255.0, alpha: 1),
      //Charcoal
      PaletteTint800Name: UIColor(red: 44/255.0, green: 53/255.0, blue: 58/255.0, alpha: 1),
      //Onyx
      PaletteTint900Name: UIColor(red: 23/255.0, green: 30/255.0, blue: 33/255.0, alpha: 1),
      ],
                         accents: nil)
  }
  
  public static func orangePalette() -> ArduinoColors {
    return ArduinoColors(withTints: [
      //Carrot 75%
      PaletteTint400Name: UIColor(red: 255/255.0, green: 179/255.0, blue: 45/255.0, alpha: 1),
      //Carrot
      PaletteTint500Name: UIColor(red: 243/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1),
      //Orange
      PaletteTint600Name: UIColor(red: 230/255.0, green: 126/255.0, blue: 34/255.0, alpha: 1)
      ],
                         accents: [PaletteAccent700Name : UIColor.white]
    )
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
