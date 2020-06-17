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

import CoreBluetooth
import XCTest

@testable import third_party_sciencejournal_ios_ScienceJournalOpen

class SensorSpec_BLESensorInterfaceTest: XCTestCase {

  func testSpecFromBLEInterface() {

    let interface = TestSensorInterface(identifier: "TEST IDENTIFIER")
    let sensorSpec = SensorSpec(bleSensorInterface: interface)

    XCTAssertEqual("TEST IDENTIFIER", sensorSpec.gadgetInfo.address)
    XCTAssertEqual("TEST PROVIDER ID", sensorSpec.gadgetInfo.providerID)
    XCTAssertEqual("TEST NAME", sensorSpec.rememberedAppearance.name)
    XCTAssertNil(sensorSpec.rememberedAppearance.iconPath?.pathString)
    XCTAssertEqual("TEST UNIT DESCRIPTION", sensorSpec.rememberedAppearance.units)
    XCTAssertEqual("TEST TEXT DESCRIPTION", sensorSpec.rememberedAppearance.shortDescription)
  }

}
