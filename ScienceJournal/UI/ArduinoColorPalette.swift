//  
//  ArduinoColorPalette.swift
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

class ArduinoColorPalette : Equatable {
  private var tints: [String : UIColor]
  private var accents: [String : UIColor]?

  init(withTints tints: [String : UIColor], accents: [String : UIColor]?) {
    self.tints = tints
    self.accents = accents
  }

  static func == (lhs: ArduinoColorPalette, rhs: ArduinoColorPalette) -> Bool {
      return
          lhs.tints == rhs.tints &&
          lhs.accents == rhs.accents
  }
  
  public static let labelColor:UIColor = ArduinoColorPalette.grayPalette.tint800!
  public static let secondaryLabelColor:UIColor = ArduinoColorPalette.grayPalette.tint500!
  public static let iconColor:UIColor = ArduinoColorPalette.grayPalette.tint500!
  public static let contentColor:UIColor = .black
  public static let containerBackgroundColor:UIColor = ArduinoColorPalette.grayPalette.tint50!
  public static let alertColor:UIColor = UIColor(red: 0.855, green: 0.357, blue: 0.29, alpha: 1)
  public static let warningColor:UIColor = UIColor(red: 0.945, green: 0.769, blue: 0.059, alpha: 1)

  public static var defaultPalette: ArduinoColorPalette {
    return orangePalette
  }
  
  public static var goldPalette: ArduinoColorPalette {
    return ArduinoColorPalette(withTints: [
      //Bronze
      PaletteTint400Name: UIColor(red: 188/255.0, green: 172/255.0, blue: 153/255.0, alpha: 1),
      //Dark Bronze
      PaletteTint500Name: UIColor(red: 178/255.0, green: 159/255.0, blue: 137/255.0, alpha: 1),
      //Light Gold
      PaletteTint600Name: UIColor(red: 168/255.0, green: 145/255.0, blue: 123/255.0, alpha: 1),
      //Gold
      PaletteTint700Name: UIColor(red: 158/255.0, green: 132/255.0, blue: 109/255.0, alpha: 1)
      ],
                         accents: nil)
  }

  public static var yellowPalette: ArduinoColorPalette {
    return ArduinoColorPalette(withTints: [
      //Sunflower
      PaletteTint400Name: UIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 1),
      //Dark Sunflower
      PaletteTint500Name: UIColor(red: 241/255.0, green: 184/255.0, blue: 15/255.0, alpha: 1),
      //Light Carrot
      PaletteTint600Name: UIColor(red: 243/255.0, green: 167/255.0, blue: 18/255.0, alpha: 1),
      //Carrot
      PaletteTint700Name: UIColor(red: 243/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1)
      ],
                         accents: nil
    )
  }
  
  public static var tealPalette: ArduinoColorPalette {
    return ArduinoColorPalette(withTints: [
      //Teal0
      PaletteTint400Name: UIColor(red: 127/255.0, green: 203/255.0, blue: 205/255.0, alpha: 1),
      //Teal0.5
      PaletteTint500Name: UIColor(red: 84/255.0, green: 189/255.0, blue: 191/255.0, alpha: 1),
      //Teal1
      PaletteTint600Name: UIColor(red: 12/255.0, green: 161/255.0, blue: 166/255.0, alpha: 1),
      //Teal2
      PaletteTint700Name: UIColor(red: 0/255.0, green: 151/255.0, blue: 157/255.0, alpha: 1),
      //Teal3
      PaletteTint800Name: UIColor(red: 0/255.0, green: 129/255.0, blue: 132/255.0, alpha: 1),
      ],
                         accents: [PaletteAccent700Name : UIColor.white]
    )
  }

  public static var grayPalette: ArduinoColorPalette {
    return ArduinoColorPalette(withTints: [
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
      PaletteTint600Name: UIColor(red: 67/255.0, green: 79/255.0, blue: 84/255.0, alpha: 1),
      //Jet
      PaletteTint700Name: UIColor(red: 55/255.0, green: 65/255.0, blue: 70/255.0, alpha: 1),
      //Charcoal
      PaletteTint800Name: UIColor(red: 44/255.0, green: 53/255.0, blue: 58/255.0, alpha: 1),
      //Onyx
      PaletteTint900Name: UIColor(red: 23/255.0, green: 30/255.0, blue: 33/255.0, alpha: 1)
      ],
                         accents: nil)
  }
  
  public static var orangePalette: ArduinoColorPalette {
    return ArduinoColorPalette(withTints: [
      //Carrot
      PaletteTint400Name: UIColor(red: 243/255.0, green: 156/255.0, blue: 18/255.0, alpha: 1),
      //Dark Carrot
      PaletteTint500Name: UIColor(red: 243/255.0, green: 137/255.0, blue: 24/255.0, alpha: 1),
      //Light Tangerine
      PaletteTint600Name: UIColor(red: 242/255.0, green: 119/255.0, blue: 31/255.0, alpha: 1),
      //Tangerine
      PaletteTint700Name: UIColor(red: 242/255.0, green: 103/255.0, blue: 39/255.0, alpha: 1)
      ],
                         accents: [PaletteAccent700Name : UIColor.white]
    )
  }

  var tint50: UIColor? {
      return tints[PaletteTint50Name]
  }

  var tint100: UIColor? {
      return tints[PaletteTint100Name]
  }

  var tint200: UIColor? {
      return tints[PaletteTint200Name]
  }

  var tint300: UIColor? {
      return tints[PaletteTint300Name]
  }

  var tint400: UIColor? {
      return tints[PaletteTint400Name]
  }

  var tint500: UIColor? {
      return tints[PaletteTint500Name]
  }

  var tint600: UIColor? {
      return tints[PaletteTint600Name]
  }

  var tint700: UIColor? {
      return tints[PaletteTint700Name]
  }

  var tint800: UIColor? {
      return tints[PaletteTint800Name]
  }

  var tint900: UIColor? {
      return tints[PaletteTint900Name]
  }

  var accent100: UIColor? {
      return accents?[PaletteAccent100Name]
  }

  var accent200: UIColor? {
      return accents?[PaletteAccent200Name]
  }

  var accent400: UIColor? {
      return accents?[PaletteAccent400Name]
  }

  var accent700: UIColor? {
      return accents?[PaletteAccent700Name]
  }

  /// Color palette options for experiment list cards.
  static let experimentListCardColorPaletteOptions = [ArduinoColorPalette.orangePalette,
                                                      ArduinoColorPalette.yellowPalette,
                                                      ArduinoColorPalette.goldPalette,
                                                      ArduinoColorPalette.tealPalette]

  /// Returns the next experiment list card color palette that is least used.
  ///
  /// - Parameter usedPalettes: Color palettes that are already in use by experiment list cards.
  /// - Returns: The next experiment list card color palette to use.
  static func nextExperimentListCardColorPalette(
      withUsedPalettes usedPalettes: [ArduinoColorPalette]) -> ArduinoColorPalette {
    return nextColorPalette(from: experimentListCardColorPaletteOptions,
                            withUsedPalettes: usedPalettes)
  }

  // MARK: - Sensor card colors

  /// Color palette options for sensor cards.
  static let sensorCardColorPaletteOptions = [ArduinoColorPalette.orangePalette,
                                              ArduinoColorPalette.yellowPalette,
                                              ArduinoColorPalette.goldPalette,
                                              ArduinoColorPalette.tealPalette]

  /// Returns the next sensor card color palette that is least used.
  ///
  /// - Parameter usedPalettes: Color palettes that are already in use by sensor cards.
  /// - Returns: The next sensor card color palette to use.
  static func nextSensorCardColorPalette(
      withUsedPalettes usedPalettes: [ArduinoColorPalette]) -> ArduinoColorPalette {
    return nextColorPalette(from: sensorCardColorPaletteOptions, withUsedPalettes: usedPalettes)
  }

  // MARK: - Private

  // Returns the color palette that is least used out of an array of colors. (Matches Android's code
  // for choosing card colors.)
  private static func nextColorPalette(from colorPalettes: [ArduinoColorPalette],
                                       withUsedPalettes
                                       usedPalettes: [ArduinoColorPalette]) -> ArduinoColorPalette {
    // Set up a dictionary for each palette to keep track of used count.
    var paletteIndexUsedCountDict = [Int : Int]()
    if !usedPalettes.isEmpty {
      for palette in usedPalettes {
        guard let index = colorPalettes.firstIndex(of: palette) else { continue }
        if paletteIndexUsedCountDict[index] == nil {
          paletteIndexUsedCountDict[index] = 1
        } else {
          paletteIndexUsedCountDict[index]! += 1
        }
      }
    }

    // Loop each palette, and if it is used fewer times than the current least used color, use it.
    // Each time around the loop increment the least used count threshold.
    var foundColor: ArduinoColorPalette?
    var leastUsed = 0
    while foundColor == nil {
      for palette in colorPalettes {
        guard let index = colorPalettes.firstIndex(of: palette),
            let paletteCount = paletteIndexUsedCountDict[index],
            paletteCount > leastUsed else {
          foundColor = palette
          break
        }
      }
      if foundColor == nil {
        leastUsed += 1
      } else {
        break
      }
    }
    return foundColor!
  }
  
}
