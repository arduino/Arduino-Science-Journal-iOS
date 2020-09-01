//  
//  Nano33IoTServiceInterface.swift
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

struct Nano33IoTIds {
  static let serviceUUID = CBUUID(string: "555a0003-0000-467a-9538-01f0652c74e8")
}

class Nano33IoTServiceInterface: BLEServiceInterface {
  var serviceId: CBUUID {
    return Nano33IoTIds.serviceUUID
  }

  var name: String {
    return "Nano 33 IoT"
  }

  var iconName: String {
    return "ic_sensor_bluetooth"
  }
  
  class func sensor(for spec: SensorSpec) -> BLESensorInterface? {
    switch spec.gadgetInfo.address {
    case Nano33IoTAccelerometerXSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: Nano33IoTAccelerometerXSensor(),
                                        serviceId: Nano33IoTIds.serviceUUID)
    case Nano33IoTAccelerometerYSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: Nano33IoTAccelerometerYSensor(),
                                        serviceId: Nano33IoTIds.serviceUUID)
    case Nano33IoTAccelerometerZSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: Nano33IoTAccelerometerZSensor(),
                                        serviceId: Nano33IoTIds.serviceUUID)
    case Nano33IoTLinearAccelerometerSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: Nano33IoTLinearAccelerometerSensor(),
                                      serviceId: Nano33IoTIds.serviceUUID)
    case Nano33IoTGyroscopeXSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: Nano33IoTGyroscopeXSensor(),
                                      serviceId: Nano33IoTIds.serviceUUID)
    case Nano33IoTGyroscopeYSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: Nano33IoTGyroscopeYSensor(),
                                      serviceId: Nano33IoTIds.serviceUUID)
    case Nano33IoTGyroscopeZSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: Nano33IoTGyroscopeZSensor(),
                                      serviceId: Nano33IoTIds.serviceUUID)
    default:
      return nil
    }
  }

  func devicesForPeripheral(_ peripheral: CBPeripheral) -> [BLESensorInterface] {
    return [
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: Nano33IoTAccelerometerXSensor(), serviceId: Nano33IoTIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: Nano33IoTAccelerometerYSensor(), serviceId: Nano33IoTIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: Nano33IoTAccelerometerZSensor(), serviceId: Nano33IoTIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: Nano33IoTLinearAccelerometerSensor(), serviceId: Nano33IoTIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: Nano33IoTGyroscopeXSensor(), serviceId: Nano33IoTIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: Nano33IoTGyroscopeYSensor(), serviceId: Nano33IoTIds.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: Nano33IoTGyroscopeZSensor(), serviceId: Nano33IoTIds.serviceUUID)
    ]
  }
}
