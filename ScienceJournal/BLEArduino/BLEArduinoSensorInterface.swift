//
//  BLEArduinoSensorInterface.swift
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

import MaterialComponents.MaterialDialogs
import third_party_sciencejournal_ios_ScienceJournalProtos

enum BLEArduinoSensorConfig: Int, Codable {
  case raw
  case temperatureCelsius
  case temperatureFahrenheit
  case light
  case resistor1kOhm
  case resistor10kOhm
  case resistor1MOhm
}

protocol BLEArduinoSensor {
  static var identifier: String { get }
  static var uuid: CBUUID { get }

  var name: String { get }
  var iconName: String { get }
  var filledIconName: String { get }
  var animatingIconName: String { get }
  var unitDescription: String? { get }
  var textDescription: String { get }
  var learnMoreInformation: Sensor.LearnMore { get }
  var options: [BLEArduinoSensorConfig] { get }

  var config: BLEArduinoSensorConfig? { get set }

  func point(for data: Data) -> Double
}

extension BLEArduinoSensor {
  static var identifier: String { uuid.uuidString }

  var options: [BLEArduinoSensorConfig] { [] }
}

class BLEArduinoSensorInterface: BLESensorInterface {
  var sensor: BLEArduinoSensor

  var identifier: String { type(of: sensor).identifier }

  var serviceId: CBUUID

  var providerId: String

  var peripheralName: String

  var name: String { sensor.name }

  var iconName: String { sensor.iconName }
  
  var filledIconName: String { sensor.filledIconName }

  var animatingIconName: String { sensor.animatingIconName }

  var config: Data? {
    get {
      guard let config = sensor.config else { return nil }
      return try? JSONEncoder().encode(config)
    }
    set {
      guard let data = newValue else { return }
      let config = try? JSONDecoder().decode(BLEArduinoSensorConfig.self,
                                             from: data)
      sensor.config = config
    }
  }

  var peripheral: CBPeripheral?

  var unitDescription: String? { sensor.unitDescription }

  var textDescription: String { sensor.textDescription }

  var hasOptions: Bool { !sensor.options.isEmpty }

  var learnMoreInformation: Sensor.LearnMore { sensor.learnMoreInformation }

  var characteristic: CBUUID { type(of: sensor).uuid }

  private var serviceScanner: BLEServiceScanner
  private var peripheralInterface: BLEPeripheralInterface?

  private lazy var clock = Clock()

  private var configViewController: ScienceKitSensorConfigViewController?
  private var configCompletionBlock: (() -> Void)?

  required init(sensor: BLEArduinoSensor,
                providerId: String,
                serviceId: CBUUID,
                peripheralName: String) {
    self.sensor = sensor
    self.providerId = providerId
    self.serviceId = serviceId
    self.peripheralName = peripheralName
    self.serviceScanner = BLEServiceScanner(services: [serviceId])
  }

  convenience init(peripheral: CBPeripheral, sensor: BLEArduinoSensor, serviceId: CBUUID) {
    self.init(sensor: sensor,
              providerId: peripheral.identifier.uuidString,
              serviceId: serviceId,
              peripheralName: peripheral.name ?? "")
  }

  convenience init(spec: SensorSpec, sensor: BLEArduinoSensor, serviceId: CBUUID) {
    self.init(sensor: sensor,
              providerId: spec.gadgetInfo.providerID,
              serviceId: serviceId,
              peripheralName: spec.gadgetInfo.hostID)
    config = spec.config
  }

  func presentOptions(from viewController: UIViewController, completion: @escaping () -> Void) {
    guard sensor.options.count > 1 else {
      completion()
      return
    }

    configCompletionBlock = completion

    let dialogController = MDCDialogTransitionController()
    // swiftlint:disable force_cast
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast
    let dialog =
      ScienceKitSensorConfigViewController(analyticsReporter: appDelegate.analyticsReporter)
    dialog.options = sensor.options
    dialog.config = sensor.config ?? .raw

    dialog.okButton.addTarget(self,
                              action: #selector(sensorConfigOKButtonPressed),
                              for: .touchUpInside)
    dialog.modalPresentationStyle = .custom
    dialog.transitioningDelegate = dialogController
    dialog.mdc_dialogPresentationController?.dismissOnBackgroundTap = false
    viewController.present(dialog, animated: true)

    configViewController = dialog
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

private extension BLEArduinoSensorInterface {
  @objc
  func sensorConfigOKButtonPressed() {
    guard let configViewController = configViewController else {
      return
    }

    sensor.config = configViewController.config

    let completion = configCompletionBlock
    configCompletionBlock = nil
    configViewController.dismiss(animated: true, completion: completion)
  }
}
