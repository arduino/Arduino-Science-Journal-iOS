//
//  Nano33BLESenseColorTemperatureSensor.swift
//  ScienceJournal
//
//  Created by Sebastian Romero on 1/09/2020.
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

import CoreBluetooth

struct Nano33BLESenseColorTemperatureSensor: BLEArduinoSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0002-0018-467a-9538-01f0652c74e8") }
  static var identifier: String { "\(uuid.uuidString)_2" }

  var name: String { String.colorTemperature }

  var iconName: String { "ic_sensor_color" }
  
  var filledIconName: String { "ic_sensor_color_filled" }

  var animatingIconName: String { "sensor_color" }

  var unitDescription: String? { String.colorTemperatureUnits }

  var textDescription: String { String.sensorDescShortMkrsciColorTemperature }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var config: BLEArduinoSensorConfig?

  func point(for data: Data) -> Double {
    guard data.count == 16 else { return 0 }

    let rawR = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: Int16.self) }
    let rawG = data.withUnsafeBytes { $0.load(fromByteOffset: 1 * 4, as: Int16.self) }
    let rawB = data.withUnsafeBytes { $0.load(fromByteOffset: 2 * 4, as: Int16.self) }

    // 1. Map RGB values to their XYZ counterparts.
    let r = (Double(rawR) / 4097.0)
    let g = (Double(rawG) / 4097.0)
    let b = (Double(rawB) / 4097.0)
    let x = (0.412453 * r) + (0.35758 * g) + (0.180423 * b)
    let y = (0.212671 * r) + (0.71516 * g) + (0.072169 * b)
    let z = (0.019334 * r) + (0.119193 * g) + (0.950227 * b)

    // 2. Calculate the chromaticity co-ordinates
    let xchrome = x / (x + y + z)
    let ychrome = y / (x + y + z)

    // 3. Use to determine the CCT
    let n = (xchrome - 0.3320) / (0.1858 - ychrome)

    // 4. Calculate the final CCT
    let cct = (449.0 * pow(n, 3)) + (3525.0 * pow(n, 2)) + (6823.3 * n) + 5520.33

    if cct > 15000.0 {
      return 15000.0
    } else if cct < 0 || cct.isNaN {
      return 0.0
    }

    return cct
  }
}
