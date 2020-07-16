//  
//  BLEScienceKitCurrentSensorSpec.swift
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

struct BLEScienceKitCurrentSensor: BLEScienceKitSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0001-4002-467a-9538-01f0652c74e8") }

  var name: String { "Current" }

  var iconName: String { "mkrsci_sensor_current" }

  var animatingIconName: String { "mkrsci_current" }

  var unitDescription: String? { "A" }

  var textDescription: String {
    "The amount of flow of charged " +
    "particles between two places" }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  func point(for data: Data) -> Double {
    let float = data.withUnsafeBytes { $0.load(as: Float.self) }
    return Double(float)
  }
}
