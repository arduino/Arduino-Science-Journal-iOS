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
    case BLEScienceKitVoltageSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitVoltageSensor())
    case BLEScienceKitCurrentSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitCurrentSensor())
    case BLEScienceKitResistanceSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitResistanceSensor())
    case BLEScienceKitInput1Sensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitInput1Sensor())
    case BLEScienceKitInput2Sensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitInput2Sensor())
    case BLEScienceKitInput3Sensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitInput3Sensor())
    case BLEScienceKitLinearAccelerometerSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitLinearAccelerometerSensor())
    case BLEScienceKitAccelerometerXSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitAccelerometerXSensor())
    case BLEScienceKitAccelerometerYSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitAccelerometerYSensor())
    case BLEScienceKitAccelerometerZSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitAccelerometerZSensor())
    case BLEScienceKitMagnetometerSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitMagnetometerSensor())
    default:
      return nil
    }
  }

  func devicesForPeripheral(_ peripheral: CBPeripheral) -> [BLESensorInterface] {
    return [
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitVoltageSensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitCurrentSensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitResistanceSensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitInput1Sensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitInput2Sensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitInput3Sensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitLinearAccelerometerSensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitAccelerometerXSensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitAccelerometerYSensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitAccelerometerZSensor()),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitMagnetometerSensor())
    ]
  }
}

extension BLEScienceKitSensorInterface {
  convenience init(peripheral: CBPeripheral, sensor: BLEScienceKitSensor) {
    self.init(sensor: sensor,
              providerId: peripheral.identifier.uuidString,
              serviceId: MKRWiFi1010Ids.serviceUUID,
              peripheralName: peripheral.name ?? "")
  }

  convenience init(spec: SensorSpec, sensor: BLEScienceKitSensor) {
    self.init(sensor: sensor,
              providerId: spec.gadgetInfo.providerID,
              serviceId: MKRWiFi1010Ids.serviceUUID,
              peripheralName: spec.gadgetInfo.hostID)
    config = spec.config
  }
}
