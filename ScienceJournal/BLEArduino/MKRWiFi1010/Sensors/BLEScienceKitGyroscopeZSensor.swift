//  
//  BLEScienceKitGyroscopeZSensor.swift
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

struct BLEScienceKitGyroscopeZSensor: BLEArduinoSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0001-5002-467a-9538-01f0652c74e8") }
  static var identifier: String { "\(uuid.uuidString)_3" }

  var name: String { "gyr_z".localized }

  var iconName: String { "ic_sensor_gyr_z" }
  
  var filledIconName: String { "ic_sensor_gyr_z_filled" }

  var animatingIconName: String { "mkrsci_gyrz" }

  var unitDescription: String? { "\u{00B0}/s" }

  var textDescription: String { "sensor_desc_short_mkrsci_gyr".localized }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var config: BLEArduinoSensorConfig?

  func point(for data: Data) -> Double {
    guard data.count == 12 else { return 0 }

    let z = data.withUnsafeBytes { $0.load(fromByteOffset: 8, as: Float.self) }

    return Double(z)
  }
}
