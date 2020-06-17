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

import XCTest

@testable import third_party_sciencejournal_ios_ScienceJournalOpen

class DevicePreferenceManagerTest: XCTestCase {

  func testHasAUserChosenAnExistingDataMigrationOption() {
    let devicePreferences = DevicePreferenceManager(defaults: createTestDefaults())
    devicePreferences.hasAUserChosenAnExistingDataMigrationOption = true
    XCTAssertTrue(devicePreferences.hasAUserChosenAnExistingDataMigrationOption)
    devicePreferences.hasAUserChosenAnExistingDataMigrationOption = false
    XCTAssertFalse(devicePreferences.hasAUserChosenAnExistingDataMigrationOption)
  }

  func testHasAUserCompletedPermissionsGuide() {
    let devicePreferences = DevicePreferenceManager(defaults: createTestDefaults())
    devicePreferences.hasAUserCompletedPermissionsGuide = true
    XCTAssertTrue(devicePreferences.hasAUserCompletedPermissionsGuide)
    devicePreferences.hasAUserCompletedPermissionsGuide = false
    XCTAssertFalse(devicePreferences.hasAUserCompletedPermissionsGuide)
  }

  func testFileSystemLayoutVersion() {
    let devicePreferences = DevicePreferenceManager(defaults: createTestDefaults())
    XCTAssertEqual(devicePreferences.fileSystemLayoutVersion, FileSystemLayout.Version.one)
    devicePreferences.fileSystemLayoutVersion = FileSystemLayout.Version.one
    XCTAssertEqual(devicePreferences.fileSystemLayoutVersion, FileSystemLayout.Version.one)
  }

}
