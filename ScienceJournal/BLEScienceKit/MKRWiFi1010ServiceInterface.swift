//  
//  MKRWiFi1010ServiceInterface.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 17/06/2020.
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

struct MKRWiFi1010Ids {
  static let serviceUUID = CBUUID(string: "555a0001-0000-467a-9538-01f0652c74e8")
}

class MKRWiFi1010ServiceInterface: BLEServiceInterface {
  var serviceId: CBUUID {
    return MKRWiFi1010Ids.serviceUUID
  }

  var name: String {
    return "MKR WiFi 1010"
  }

  var iconName: String {
    return "ic_sensor_bluetooth"
  }

  class func sensor(for spec: SensorSpec) -> BLESensorInterface? {
    switch spec.gadgetInfo.address {
    case BLEScienceKitVoltageSensor.uuid.uuidString:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitVoltageSensor())
    case BLEScienceKitCurrentSensor.uuid.uuidString:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitCurrentSensor())
    default:
      return nil
    }
  }

  func devicesForPeripheral(_ peripheral: CBPeripheral) -> [BLESensorInterface] {
    return [
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitVoltageSensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitCurrentSensor()),
    ]
  }
}

extension BLEScienceKitSensorInterface {
  convenience init(peripheral: CBPeripheral, sensor: BLEScienceKitSensor) {
    self.init(sensor: sensor,
              providerId: peripheral.identifier.uuidString,
              serviceId: MKRWiFi1010Ids.serviceUUID)
  }

  convenience init(spec: SensorSpec, sensor: BLEScienceKitSensor) {
    self.init(sensor: sensor,
              providerId: spec.gadgetInfo.providerID,
              serviceId: MKRWiFi1010Ids.serviceUUID)
  }
}
