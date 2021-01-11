//  
//  BLEScienceKitInput2Sensor.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 27/07/2020.
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

struct BLEScienceKitInput2Sensor: BLEArduinoSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0001-2002-467a-9538-01f0652c74e8") }

  var name: String { "input_2".localized }

  var iconName: String { "ic_sensor_input_2" }
  
  var filledIconName: String { "ic_sensor_input_2_filled" }

  var animatingIconName: String {
    switch config {
    case .light:
      return "mkrsci_light"
    default:
      return "mkrsci"
    }
  }

  var unitDescription: String? {
    switch config {
    case .light:
      return "lux"
    default:
      return nil
    }
  }

  var textDescription: String {
    switch config {
    case .light:
      return "sensor_desc_short_mkrsci_color_illuminance".localized
    default:
      return ""
    }
  }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var options: [BLEArduinoSensorConfig] = [
    .light, .raw
  ]

  var config: BLEArduinoSensorConfig? = .raw

  func point(for data: Data) -> Double {
    let rawValue = data.withUnsafeBytes { $0.load(as: Int16.self) }

    switch config {
    case .light:
      return light(from: rawValue)
    default:
      return Double(rawValue)
    }
  }

  private func light(from rawValue: Int16) -> Double {
    ((Double(rawValue) * Double(3300)) / Double(1023)) * Double(0.5)
  }
}
