/*
 *  Copyright 2019 Google LLC. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import Foundation

import MaterialComponents.MaterialPalettes

/// Represents a sensor card cell in the observe view.
class SensorCard: NSObject {

  // MARK: - Properties

  /// The cell state for the sensor card.
  var cellState: SensorCardCell.State

  /// The color pallette the card should use for certain UI elements.
  var colorPalette: ArduinoColorPalette

  /// The sensor the card is displaying.
  var sensor: Sensor {
    didSet {
      sensorLayout?.sensorID = sensor.sensorId
    }
  }

  /// A chart controller to display sensor data in a chart .
  var chartController: ChartController

  /// The tone generator for sensor data sonification.
  let toneGenerator = ToneGenerator()

  /// The stat calculator when recording.
  let statCalculator = StatCalculator()

  /// A sensor layout to capture the presentation settings.
  var sensorLayout: SensorLayout?

  // MARK: - Lifecycle

  /// Designated initializer.
  ///
  /// - Parameters:
  ///   - cellStateOptions: The cell state options for the sensor card.
  ///   - sensor: The sensor displayed in the sensor card.
  ///   - colorPalette: The color palette of the sensor card.
  init(cellStateOptions: SensorCardCell.State.Options = .normal,
       sensor: Sensor,
       colorPalette: ArduinoColorPalette) {
    cellState = SensorCardCell.State(options: cellStateOptions)
    self.colorPalette = colorPalette
    self.sensor = sensor
    chartController = ChartController(placementType: .observe, colorPalette: colorPalette)
  }

}
