//  
//  BLEScienceKitSensorInterface.swift
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

import UIKit
import CoreBluetooth

import third_party_sciencejournal_ios_ScienceJournalProtos

protocol BLEScienceKitSensor {
  static var uuid: CBUUID { get }

  var name: String { get }
  var iconName: String { get }
  var animatingIconName: String { get }
  var unitDescription: String? { get }
  var textDescription: String { get }
  var learnMoreInformation: Sensor.LearnMore { get }

  func point(for data: Data) -> Double
}

class BLEScienceKitSensorInterface: BLESensorInterface {
  let sensor: BLEScienceKitSensor

  var identifier: String { type(of: sensor).uuid.uuidString }

  var serviceId: CBUUID

  var providerId: String

  var name: String { sensor.name }

  var iconName: String { sensor.iconName }

  var animatingIconName: String { sensor.animatingIconName }

  var config: Data?

  var peripheral: CBPeripheral?

  var unitDescription: String? { sensor.unitDescription }

  var textDescription: String { sensor.textDescription }

  var hasOptions: Bool { false }

  var learnMoreInformation: Sensor.LearnMore { sensor.learnMoreInformation }

  var characteristic: CBUUID { CBUUID(string: identifier) }

  private var serviceScanner: BLEServiceScanner
  private var peripheralInterface: BLEPeripheralInterface?

  private lazy var clock = Clock()

  required init(sensor: BLEScienceKitSensor,
                providerId: String,
                serviceId: CBUUID) {
    self.sensor = sensor
    self.providerId = providerId
    self.serviceId = serviceId
    self.serviceScanner = BLEServiceScanner(services: [serviceId])
  }

  func presentOptions(from viewController: UIViewController, completion: @escaping () -> Void) {

  }

  func connect(_ completion: @escaping (Bool) -> Void) {
    serviceScanner.connectToPeripheral(withIdentifier: providerId) { (peripheral, error) in
      // Stop scanning.
      self.serviceScanner.stopScanning()

      guard peripheral != nil else {
        print("[BluetoothSensor] Error connecting to " +
              "peripheral: \(String(describing: error?.peripheral.name)) " +
              "address: \(String(describing: error?.peripheral.identifier))")
        // TODO: Pass along connection error http://b/64684813
        completion(false)
        return
      }

      self.peripheral = peripheral

      completion(true)
    }
  }

  func startObserving(_ listener: @escaping (DataPoint) -> Void) {
    guard let peripheral = peripheral else { return }

    let interface = BLEPeripheralInterface(peripheral: peripheral,
                                           serviceUUID: serviceId,
                                           characteristicUUIDs: [characteristic])
    interface.updatesForCharacteristic(characteristic, block: { [clock, sensor] data in
      let point = sensor.point(for: data)
      let dataPoint = DataPoint(x: clock.millisecondsSince1970,
                                y: point)
      listener(dataPoint)
    })
    self.peripheralInterface = interface
  }

  func stopObserving() {
    peripheralInterface?.stopUpdatesForCharacteristic(characteristic)
  }
}
