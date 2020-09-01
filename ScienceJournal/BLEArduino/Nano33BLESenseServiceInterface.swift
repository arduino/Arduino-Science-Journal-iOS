//  
//  Nano33BLESenseServiceInterface.swift
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

struct Nano33BLESenseIds {
  static let serviceUUID = CBUUID(string: "555a0002-0000-467a-9538-01f0652c74e8")
}

class Nano33BLESenseServiceInterface: BLEServiceInterface {
  var serviceId: CBUUID {
    return Nano33BLESenseIds.serviceUUID
  }

  var name: String {
    return "Nano 33 BLE Sense"
  }

  var iconName: String {
    return "ic_sensor_bluetooth"
  }

  class func sensor(for spec: SensorSpec) -> BLESensorInterface? {
    switch spec.gadgetInfo.address {
    case BLENano33BLESenseTemperatureSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLENano33BLESenseTemperatureSensor(),
                                          serviceId: Nano33BLESenseIds.serviceUUID)
    case BLENano33BLESenseAccelerometerXSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLENano33BLESenseAccelerometerXSensor(),
                                        serviceId: Nano33BLESenseIds.serviceUUID)
    case BLENano33BLESenseAccelerometerYSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLENano33BLESenseAccelerometerYSensor(),
                                        serviceId: Nano33BLESenseIds.serviceUUID)
    case BLENano33BLESenseAccelerometerZSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLENano33BLESenseAccelerometerZSensor(),
                                        serviceId: Nano33BLESenseIds.serviceUUID)
    case BLENano33BLESenseLinearAccelerometerSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLENano33BLESenseLinearAccelerometerSensor(),
                                      serviceId: Nano33BLESenseIds.serviceUUID)
    default:
      return nil
    }
  }

  func devicesForPeripheral(_ peripheral: CBPeripheral) -> [BLESensorInterface] {
    return [
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLENano33BLESenseTemperatureSensor(), serviceId: Nano33BLESenseIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLENano33BLESenseAccelerometerXSensor(), serviceId: Nano33BLESenseIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLENano33BLESenseAccelerometerYSensor(), serviceId: Nano33BLESenseIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLENano33BLESenseAccelerometerZSensor(), serviceId: Nano33BLESenseIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLENano33BLESenseLinearAccelerometerSensor(), serviceId: Nano33BLESenseIds.serviceUUID)
    ]
  }
}
