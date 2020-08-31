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

struct BLENano33BLESenseTemperatureSensor: BLEScienceKitSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0002-0014-467a-9538-01f0652c74e8") }

  var name: String { "ambient_temperature".localized }

  var iconName: String { "arduino_sensor_temperature" }

  var animatingIconName: String { "arduino_temperature" }

  var unitDescription: String? { "temperature_units".localized }

  var textDescription: String {
    "An instrument used to measure " +
    "the temperature of the envirionment" }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var config: BLEScienceKitSensorConfig?

  func point(for data: Data) -> Double {
    guard data.count == 4 else { return 0 }
    let temperature = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: Float.self) }
    return Double(temperature)
  }
}
