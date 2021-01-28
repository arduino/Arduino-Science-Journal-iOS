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
    case Nano33BLESenseTemperatureSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseTemperatureSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseAccelerometerXSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseAccelerometerXSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseAccelerometerYSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseAccelerometerYSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseAccelerometerZSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseAccelerometerZSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseLinearAccelerometerSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseLinearAccelerometerSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseGyroscopeXSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseGyroscopeXSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseGyroscopeYSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseGyroscopeYSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseGyroscopeZSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseGyroscopeZSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseMagnetometerSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseMagnetometerSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseBarometricPressureSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseBarometricPressureSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseHumiditySensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseHumiditySensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseProximitySensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseProximitySensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseColorIlluminanceSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseColorIlluminanceSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseColorTemperatureSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseColorTemperatureSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    case Nano33BLESenseResistanceSensor.identifier:
      return BLEArduinoSensorInterface(spec: spec,
                                       sensor: Nano33BLESenseResistanceSensor(),
                                       serviceId: Nano33BLESenseIds.serviceUUID)
    default:
      return nil
    }
  }

  func devicesForPeripheral(_ peripheral: CBPeripheral) -> [BLESensorInterface] {
    return [
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseTemperatureSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseAccelerometerXSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseAccelerometerYSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseAccelerometerZSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseLinearAccelerometerSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseGyroscopeXSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseGyroscopeYSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseGyroscopeZSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseMagnetometerSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseBarometricPressureSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseHumiditySensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseProximitySensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseColorIlluminanceSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseColorTemperatureSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID),
      BLEArduinoSensorInterface(peripheral: peripheral,
                                sensor: Nano33BLESenseResistanceSensor(),
                                serviceId: Nano33BLESenseIds.serviceUUID)
    ]
  }
}
