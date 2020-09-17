//  
//  Nano33BLESenseProximitySensor.swift
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

struct Nano33BLESenseProximitySensor: BLEScienceKitSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0002-0017-467a-9538-01f0652c74e8") }

  var name: String { "proximity".localized }

  var iconName: String { "sensor_proximity" }

  var animatingIconName: String { "nano33_ble_sense_proximity" }

  var unitDescription: String? { "raw_units".localized }

  var textDescription: String {
    "An instrument used to measure " +
    "the proximity to an object" }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var config: BLEScienceKitSensorConfig?

  func point(for data: Data) -> Double {
    guard data.count == 4 else { return 0 }
    let proximity = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: UInt32.self) }
    return 100.0 - ((Double(proximity) / 255.0) * 100.0)
  }
}