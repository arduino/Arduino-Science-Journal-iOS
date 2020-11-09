//  
//  BLEScienceKitMagnetometerSensor.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 16/07/2020.
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

struct BLEScienceKitMagnetometerSensor: BLEArduinoSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0001-5003-467a-9538-01f0652c74e8") }

  var name: String { "magnetic_field_strength".localized }

  var iconName: String { "ic_sensor_magnet" }
  
  var filledIconName: String { "ic_sensor_magnet_filled" }

  var animatingIconName: String { "mkrsci_magnetometer" }

  var unitDescription: String? { "magnetic_strength_units".localized }

  var textDescription: String { "sensor_desc_short_mkrsci_magnetometer".localized }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var config: BLEArduinoSensorConfig?

  func point(for data: Data) -> Double {
    guard data.count == 12 else { return 0 }

    let a = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: Float.self) }
    let b = data.withUnsafeBytes { $0.load(fromByteOffset: 4, as: Float.self) }
    let c = data.withUnsafeBytes { $0.load(fromByteOffset: 8, as: Float.self) }

    return Double(sqrt(
      pow(a, 2) + pow(b, 2) + pow(c, 2)
    ) * 100)
  }
}
