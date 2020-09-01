//  
//  ScienceKitSensorConfigSelectorView.swift
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

extension BLEScienceKitSensorConfig {
  var name: String {
    switch self {
    case .raw:
      return "Raw"
    case .temperatureCelsius:
      return "Temperature (Celsius)"
    case .temperatureFahrenheit:
      return "Temperature (Fahrenheit)"
    case .light:
      return "Light"
    }
  }

  var image: UIImage {
    switch self {
    case .temperatureCelsius, .temperatureFahrenheit:
      return UIImage(named: "ic_sensor_temperature")!
    case .light:
      return UIImage(named: "ic_sensor_light")!
    case .raw:
      return UIImage(named: "ic_sensor_raw")!
    }
  }
}

class ScienceKitSensorConfigSelectorView: OptionSelectorView {
  override var headerLabelText: String {
    return String.deviceOptionsSensorLabelText
  }

  convenience init(options: [BLEScienceKitSensorConfig]) {
    self.init()
    self.options = options
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureView()
  }

  /// The sensor config type option delegate.
  weak var typeDelegate: SensorConfigTypeOptionDelegate?

  /// The selected config type.
  var configType = BLEScienceKitSensorConfig.raw {
    didSet {
      guard configType != oldValue else { return }
      selectionLabel.text = configType.name
      typeDelegate?.sensorConfigTypeOptionSelectionChanged()
    }
  }

  var options = [BLEScienceKitSensorConfig]()

  override func dropDownButtonPressed() {
    var actions = [PopUpMenuAction]()
    for option in options {
      let action = PopUpMenuAction(title: option.name, icon: option.image) { (_) in
        self.configType = option
      }
      actions.append(action)
    }
    optionSelectorDelegate?.optionSelectorView(self,
                                               didPressShowOptions: actions,
                                               coveringView: selectionLabel)
  }

  private func configureView() {
    selectionLabel.text = configType.name
  }
}
