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

public class Clock {

  public init() {}

  var millisecondsSince1970: Int64 {
    return Date().millisecondsSince1970
  }

  /// Returns a date object set to now.
  var now: Date {
    return Date(milliseconds: millisecondsSince1970)
  }

}
