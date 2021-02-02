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

extension Bundle {

  /// Returns the current bundle, based on the AppDelegate class. For open-source, this will always
  /// be equivalent to Bundle.main.
  static var currentBundle: Bundle = {
    return Bundle(for: AppDelegateOpen.self)
  }()

  /// Returns the app version string.
  static var appVersionString: String {
    let dictionary = Bundle.currentBundle.infoDictionary!
    // swiftlint:disable force_cast
    return dictionary["CFBundleVersion"] as! String
    // swiftlint:enable force_cast
  }

  /// Returns the build number as an integer.
  static var buildVersion: Int32 {
    #if SCIENCEJOURNAL_DEV_BUILD
      // This can be set to arbitrary values in dev as needed.
      return 9999
    #else
      guard let version = Int32(appVersionString) else {
        fatalError("Unable to get build version.")
      }
      return version
    #endif
  }

  /// Returns the strings sub-bundle or nil if it is not found.
  static var stringsBundle: Bundle? = {
    // Look for the Strings.bundle sub-bundle.
    guard let subBundlePath =
        Bundle.currentBundle.path(forResource: "Strings", ofType: "bundle") else {
      return nil
    }

    return Bundle(url: URL(fileURLWithPath: subBundlePath, isDirectory: true))
  }()

  /// Returns the Google client ID to be used for the authentication
  public static var googleClientID: String {
    let dictionary = Bundle.currentBundle.infoDictionary!
    // swiftlint:disable force_cast
    return dictionary["GoogleClientID"] as! String
    // swiftlint:enable force_cast
  }

}
