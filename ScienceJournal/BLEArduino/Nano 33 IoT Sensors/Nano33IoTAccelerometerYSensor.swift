//  
//  BLEScienceKitAccelerometerYSensor.swift
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

struct Nano33IoTAccelerometerYSensor: BLEScienceKitSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0003-0011-467a-9538-01f0652c74e8") }
  static var identifier: String { "\(uuid.uuidString)_2" }

  var name: String { "acc_y".localized }

  var iconName: String { "mkrsci_sensor_acc_y" }

  var animatingIconName: String { "mkrsci_accy" }

  var unitDescription: String? { "acc_units".localized }

  var textDescription: String { "sensor_desc_short_mkrsci_acc".localized }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var config: BLEScienceKitSensorConfig?

  func point(for data: Data) -> Double {
    guard data.count == 12 else { return 0 }

    let y = data.withUnsafeBytes { $0.load(fromByteOffset: 4, as: Float.self) }

    return Double(y) * -10
  }
}
