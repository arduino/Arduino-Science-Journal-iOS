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

class ZoomPresenterTest: XCTestCase {

  func testZeroTotalDuration() {
    let sensorStats = DisplaySensorStats(minValue: 0,
                                         averageValue: 50,
                                         maxValue: 100,
                                         numberOfValues: 0,
                                         totalDuration: 0,
                                         zoomPresenterTierCount: 1,
                                         zoomLevelBetweenTiers: 20)
    let zoomPresenter = ZoomPresenter(sensorStats: sensorStats)
    XCTAssertEqual(0, zoomPresenter.updateTier(forVisibleDuration: 100))
  }

  func testZeroVisibleDuration() {
    let sensorStats = DisplaySensorStats(minValue: 0,
                                         averageValue: 50,
                                         maxValue: 100,
                                         numberOfValues: 1000,
                                         totalDuration: 5000,
                                         zoomPresenterTierCount: 1,
                                         zoomLevelBetweenTiers: 20)
    let zoomPresenter = ZoomPresenter(sensorStats: sensorStats)
    XCTAssertEqual(0, zoomPresenter.updateTier(forVisibleDuration: 0))
  }

}
