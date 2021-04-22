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

class AppFlowViewControllerTest: XCTestCase {

  var appFlowViewController: AppFlowViewController!
  private var mockAccountsManager: MockAccountsManager!
  let mockDriveConstructor = MockDriveConstructor()

  override func setUp() {
    super.setUp()

    mockAccountsManager =
        MockAccountsManager(mockAuthAccount: MockAuthAccount(ID: "AppFlowViewControllerTestID"))
    let analyticsReporter = AnalyticsReporterOpen()
    let sensorController = MockSensorController()
    let fileSystemLayout = FileSystemLayout(baseURL: createUniqueTestDirectoryURL())
    #if FEATURE_FIREBASE_RC
    appFlowViewController =
        AppFlowViewController(fileSystemLayout: fileSystemLayout,
                              accountsManager: mockAccountsManager,
                              analyticsReporter: analyticsReporter,
                              commonUIComponents: CommonUIComponentsOpen(),
                              drawerConfig: DrawerConfigOpen(),
                              driveConstructor: mockDriveConstructor,
                              feedbackReporter: FeedbackReporterOpen(),
                              networkAvailability: SettableNetworkAvailability(),
                              remoteConfigManager: RemoteConfigManagerDisabled(),
                              sensorController: sensorController)
    #else
    appFlowViewController =
        AppFlowViewController(fileSystemLayout: fileSystemLayout,
                              accountsManager: mockAccountsManager,
                              analyticsReporter: analyticsReporter,
                              commonUIComponents: CommonUIComponentsOpen(),
                              drawerConfig: DrawerConfigOpen(),
                              driveConstructor: mockDriveConstructor,
                              feedbackReporter: FeedbackReporterOpen(),
                              networkAvailability: SettableNetworkAvailability(),
                              sensorController: sensorController)
    #endif
  }

  func testAccountUserManagerUpdatesForNewAccounts() {
    // The account user manager should be for the accounts manager's current account.
    let accountID = "AppFlowViewControllerTestID"
    mockAccountsManager.mockAuthAccount = MockAuthAccount(ID: accountID)
    let accountUserManager = appFlowViewController.currentAccountUserManager!
    XCTAssertEqual(accountUserManager.account.ID, mockAccountsManager.currentAccount!.ID)
    XCTAssertEqual(accountUserManager.account.ID, accountID)

    // The account user manager property should continue to return the same instance.
    XCTAssertTrue(appFlowViewController.currentAccountUserManager! === accountUserManager)

    // When the current account changes, there should be a new account user manager.
    let newAccountID = "AppFlowViewControllerTestNewID"
    mockAccountsManager.mockAuthAccount = MockAuthAccount(ID: newAccountID)
    let newAccountUserManager = appFlowViewController.currentAccountUserManager!
    XCTAssertEqual(newAccountUserManager.account.ID, mockAccountsManager.currentAccount!.ID)
    XCTAssertEqual(newAccountUserManager.account.ID, newAccountID)

    // The account user manager property should continue to return the same instance.
    XCTAssertTrue(appFlowViewController.currentAccountUserManager! === newAccountUserManager)
  }

}
