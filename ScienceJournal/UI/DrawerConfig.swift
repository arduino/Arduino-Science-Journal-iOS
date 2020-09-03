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

import UIKit

/// A protocol that defines a config object for drawer items and their view controllers.
public protocol DrawerConfig {

  /// Configures and returns all drawer items. Configuration is done in a func rather than an init
  /// because DrawerConfig classes are injected at the AppDelegate level, which means an init would
  /// instantiate related view controllers on app launch rather than when we actually need to use
  /// them.
  ///
  /// - Parameters:
  ///   - analyticsReporter: The analytics reporter.
  ///   - preferenceManager: A preference manager.
  ///   - sensorController: The sensor controller.
  ///   - sensorDataManager: A sensor data manager.
  /// - Returns: A tuple with keyed drawer items, and an array of ordered drawer items.
  func configuredDrawerItems(analyticsReporter: AnalyticsReporter,
                             preferenceManager: PreferenceManager,
                             sensorController: SensorController,
                             sensorDataManager: SensorDataManager) ->
      (keyedDrawerItems: [String: DrawerItem], drawerItems: [DrawerItem])

}
