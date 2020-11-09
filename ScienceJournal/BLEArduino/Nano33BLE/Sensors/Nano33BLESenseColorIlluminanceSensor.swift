//
//  Nano33BLESenseColorIlluminanceSensor.swift
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

struct Nano33BLESenseColorIlluminanceSensor: BLEArduinoSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0002-0018-467a-9538-01f0652c74e8") }
  static var identifier: String { "\(uuid.uuidString)_1" }

  var name: String { String.ambientLight }

  var iconName: String { "ic_sensor_light" }
  
  var filledIconName: String { "ic_sensor_light_filled" }

  var animatingIconName: String { "mkrsci_light" }

  var unitDescription: String? { String.ambientLightUnits }

  var textDescription: String { String.sensorDescShortMkrsciColorIlluminance }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var config: BLEArduinoSensorConfig?

  func point(for data: Data) -> Double {
    guard data.count == 16 else { return 0 }

    let illuminance = data.withUnsafeBytes { $0.load(fromByteOffset: 3 * 4, as: Int16.self) }

    return (Double(illuminance) / 4097.0) * 2.8 * 1000.0
  }
}
