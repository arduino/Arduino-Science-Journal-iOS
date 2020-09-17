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
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitVoltageSensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitCurrentSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitCurrentSensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitResistanceSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitResistanceSensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitInput1Sensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitInput1Sensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitInput2Sensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitInput2Sensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitInput3Sensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec, sensor: BLEScienceKitInput3Sensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitLinearAccelerometerSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitLinearAccelerometerSensor(),
                                          serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitAccelerometerXSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitAccelerometerXSensor(),
                                          serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitAccelerometerYSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitAccelerometerYSensor(),
                                          serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitAccelerometerZSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitAccelerometerZSensor(),
                                          serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitMagnetometerSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitMagnetometerSensor(),
                                          serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitGyroscopeXSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitGyroscopeXSensor(),
                                          serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitGyroscopeYSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitGyroscopeYSensor(),
                                          serviceId: MKRWiFi1010Ids.serviceUUID)
    case BLEScienceKitGyroscopeZSensor.identifier:
      return BLEScienceKitSensorInterface(spec: spec,
                                          sensor: BLEScienceKitGyroscopeZSensor(),
                                          serviceId: MKRWiFi1010Ids.serviceUUID)
    default:
      return nil
    }
  }

  func devicesForPeripheral(_ peripheral: CBPeripheral) -> [BLESensorInterface] {
    return [
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitVoltageSensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitCurrentSensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitResistanceSensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitInput1Sensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitInput2Sensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral, sensor: BLEScienceKitInput3Sensor(),
      serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitLinearAccelerometerSensor(),
                                   serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitAccelerometerXSensor(),
                                   serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitAccelerometerYSensor(),
                                   serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitAccelerometerZSensor(),
                                   serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitMagnetometerSensor(),
                                   serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitGyroscopeXSensor(),
                                   serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitGyroscopeYSensor(),
                                   serviceId: MKRWiFi1010Ids.serviceUUID),
      BLEScienceKitSensorInterface(peripheral: peripheral,
                                   sensor: BLEScienceKitGyroscopeZSensor(),
                                   serviceId: MKRWiFi1010Ids.serviceUUID)
    ]
  }
}
