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
  static let voltageUUID = CBUUID(string: "555a0001-4001-467a-9538-01f0652c74e8")

  static let voltageProviderID = "arduino_sk_voltage"
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
    switch spec.gadgetInfo.providerID {
    case MKRWiFi1010Ids.voltageProviderID:
      return BLEScienceKitVoltageSensorInterface(spec: spec)
    default:
      return nil
    }
  }

  func devicesForPeripheral(_ peripheral: CBPeripheral) -> [BLESensorInterface] {
    return [BLEScienceKitVoltageSensorInterface(peripheral: peripheral)]
  }
}

extension BLEScienceKitVoltageSensorInterface {
  convenience init(peripheral: CBPeripheral) {
    self.init(providerId: MKRWiFi1010Ids.voltageProviderID,
              identifier: peripheral.identifier.uuidString,
              serviceId: MKRWiFi1010Ids.serviceUUID,
              characteristic: MKRWiFi1010Ids.voltageUUID)
  }

  convenience init(spec: SensorSpec) {
    self.init(providerId: spec.gadgetInfo.providerID,
              identifier: spec.gadgetInfo.address,
              serviceId: MKRWiFi1010Ids.serviceUUID,
              characteristic: MKRWiFi1010Ids.voltageUUID)
  }
}
