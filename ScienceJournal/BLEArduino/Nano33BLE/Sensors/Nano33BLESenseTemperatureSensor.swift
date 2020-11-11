//
//  Nano33BLESenseTemperatureSensor.swift
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

struct Nano33BLESenseTemperatureSensor: BLEArduinoSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0002-0014-467a-9538-01f0652c74e8") }

  var name: String { "ambient_temperature".localized }

  var iconName: String { "ic_sensor_temperature" }
  
  var filledIconName: String { iconName }

  var animatingIconName: String { "mkrsci_temperature" }

  var unitDescription: String? {
    switch config {
    case .temperatureCelsius:
      return "temperature_units".localized
    case .temperatureFahrenheit:
      return "\u{00B0}F"
    default:
      return nil
    }
  }

  var textDescription: String { "sensor_desc_short_mkrsci_temperature".localized }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var options: [BLEArduinoSensorConfig] = [
    .temperatureCelsius, .temperatureFahrenheit
  ]

  var config: BLEArduinoSensorConfig? = .temperatureCelsius

  func point(for data: Data) -> Double {
    guard data.count == 4 else { return 0 }
    let temperature = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: Float.self) }

    switch config {
    case .temperatureFahrenheit:
      return Double(temperature * (9.0 / 5.0) + 32.0)
    default:
      return Double(temperature)
    }

  }
}
