//  
//  BLEScienceKitVoltageSensorInterface.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 18/06/2020.
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

class BLEScienceKitVoltageSensorInterface: BLESensorInterface {
  let characteristic: CBUUID

  var identifier: String

  var serviceId: CBUUID

  var providerId: String

  // FIXME: Localize
  var name: String { "Voltage" }

  var iconName: String { "mkrsci_sensor_voltage" }

  var animatingIconName: String { "mkrsci_voltage" }

  var config: Data?

  var peripheral: CBPeripheral?

  var unitDescription: String? { "V" }

  // FIXME: Localize
  var textDescription: String {
    "The difference in electric " +
    "potential between two places " +
    "that allows a current to flow" }

  var hasOptions: Bool { false }

  // FIXME: Change
  var learnMoreInformation: Sensor.LearnMore = Sensor.LearnMore(firstParagraph: "",
                                                                secondParagraph: "",
                                                                imageName: "")

  private var serviceScanner: BLEServiceScanner
  private var peripheralInterface: BLEPeripheralInterface?

  private lazy var clock = Clock()

  required init(providerId: String,
                identifier: String,
                serviceId: CBUUID,
                characteristic: CBUUID) {
    self.providerId = providerId
    self.characteristic = characteristic
    self.identifier = identifier
    self.serviceId = serviceId
    self.serviceScanner = BLEServiceScanner(services: [serviceId])
  }

  func presentOptions(from viewController: UIViewController, completion: @escaping () -> Void) {

  }

  func connect(_ completion: @escaping (Bool) -> Void) {
    serviceScanner.connectToPeripheral(withIdentifier: identifier) { (peripheral, error) in
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
    interface.updatesForCharacteristic(characteristic, block: { [clock] data in
      let float = data.withUnsafeBytes { $0.load(as: Float.self) }
      let dataPoint = DataPoint(x: clock.millisecondsSince1970,
                                y: Double(float))
      listener(dataPoint)
    })
    self.peripheralInterface = interface
  }

  func stopObserving() {
    peripheralInterface?.stopUpdatesForCharacteristic(characteristic)
  }
}
