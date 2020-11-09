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

struct Nano33BLESenseResistanceSensor: BLEArduinoSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0002-0020-467a-9538-01f0652c74e8") }

  var name: String { "resistance".localized }

  var iconName: String { "ic_sensor_resistance" }
  
  var filledIconName: String { "ic_sensor_resistance_filled" }

  var animatingIconName: String { "mkrsci_resistance" }

  var unitDescription: String? { "k\u{03A9}" }

  var textDescription: String { "sensor_desc_short_mkrsci_resistance".localized }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var options: [BLEArduinoSensorConfig] = [
    .resistor1kOhm, .resistor10kOhm, .resistor1MOhm
  ]

  var config: BLEArduinoSensorConfig? = .resistor10kOhm

  func point(for data: Data) -> Double {
    guard data.count == 4 else { return 0 }
    
    var resistanceR1:Float
    
    switch config {
    case .resistor1kOhm:
      resistanceR1 = 1000
    case .resistor10kOhm:
      resistanceR1 = 10000
    case .resistor1MOhm:
      resistanceR1 = 1000000
    default:
      resistanceR1 = 10000
    }
    
    let voltageRatio = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: Float.self) }
    let resistanceR2 = resistanceR1 * (1 / (voltageRatio - 1))
    return Double(resistanceR2 / 1000)
  }
}
