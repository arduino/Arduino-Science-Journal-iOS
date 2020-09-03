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

extension TimeInterval {

  /// A date components formatter.
  static let intervalFormatter: DateComponentsFormatter = {
    return DateComponentsFormatter.intervalFormatter(withUnitsStyle: .abbreviated)
  }()

  /// A date components formatter for accessibility without abbreviated units.
  static let accessibleIntervalFormatter: DateComponentsFormatter = {
    return DateComponentsFormatter.intervalFormatter(withUnitsStyle: .spellOut)
  }()

  /// A duration value to use in animations that inherit their duration.
  static let inherited: TimeInterval = 0

  /// Returns the time interval as a string in component format with hours, minutes and seconds.
  /// Example: "1h 46m 11s"
  var durationString: String {
    return TimeInterval.intervalFormatter.string(from: self) ?? ""
  }

  /// Returns the time interval as an accessible string in component format with hours, minutes and
  /// seconds without abbreviation.
  /// Example: "One hour 46 minutes 11 seconds"
  var accessibleDurationString: String {
    return TimeInterval.accessibleIntervalFormatter.string(from: self) ?? ""
  }

}
