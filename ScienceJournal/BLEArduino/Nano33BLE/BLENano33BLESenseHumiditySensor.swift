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

struct Nano33BLESenseHumiditySensor: BLEScienceKitSensor {
  static var uuid: CBUUID { CBUUID(string: "555a0002-0016-467a-9538-01f0652c74e8") }

  var name: String { "humidity".localized }

  var iconName: String { "sensor_humidity" }

  var animatingIconName: String { "sensor_humidity" }

  var unitDescription: String? { "raw_units".localized }

  var textDescription: String {
    "An instrument used to measure " +
    "the humidity of the envirionment" }

  var learnMoreInformation: Sensor.LearnMore {
    Sensor.LearnMore(firstParagraph: "",
                     secondParagraph: "",
                     imageName: "")
  }

  var config: BLEScienceKitSensorConfig?

  func point(for data: Data) -> Double {
    guard data.count == 4 else { return 0 }
    let humidity = data.withUnsafeBytes { $0.load(fromByteOffset: 0, as: Float.self) }
    return Double(humidity)
  }
}
