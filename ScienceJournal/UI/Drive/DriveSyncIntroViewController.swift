//  
//  DriveSyncIntroViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 05/01/21.
//  Copyright © 2021 Arduino. All rights reserved.
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
import RxSwift
import GoogleAPIClientForREST
import MaterialComponents.MaterialSnackbar

class DriveSyncIntroViewController: WizardViewController {

  let authenticationManager: AuthenticationManager

  private(set) lazy var introView = DriveSyncIntroView()

  private var disposeBag = DisposeBag()

  init(authenticationManager: AuthenticationManager) {
    self.authenticationManager = authenticationManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    wizardView.title = String.driveSyncIntroTitle
    wizardView.text = String.driveSyncIntroText
    wizardView.contentView = introView

    introView.learnMoreButton.addTarget(self, action: #selector(showMoreInfo(_:)), for: .touchUpInside)
    introView.googleDriveButton.addTarget(self, action: #selector(setupGoogleDrive(_:)), for: .touchUpInside)
    introView.skipButton.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
  }

  @objc private func showMoreInfo(_ sender: UIButton) {
    let alertController = MDCAlertController(title: nil,
                                             message: String.driveSyncIntroMoreText)
    alertController.addAction(MDCAlertAction(title: String.actionOk))
    alertController.accessibilityViewIsModal = true
    present(alertController, animated: true)
  }

  @objc private func setupGoogleDrive(_ sender: UIButton) {
    sender.isEnabled = false

    authenticationManager.googleScopes = Constants.GoogleSignInScopes.drive
    authenticationManager.signIn(with: .google, from: self)
      .withUnretained(self)
      .subscribe { (owner, user) in
        owner.handleAuthenticatedUser(user)
      } onError: { _ in
        // TODO: show error
      } onDisposed: {
        sender.isEnabled = true
      }
      .disposed(by: disposeBag)
  }

  private func handleAuthenticatedUser(_ user: User) {
    guard let authorizer = user.googleUser.authentication.fetcherAuthorizer() else {
      // TODO: show error
      return
    }

    let service = GTLRDriveService()
    service.authorizer = authorizer
    service.shouldFetchNextPages = true

    let driveManager = DriveManager(service: service)

    let folderPicker = DriveSyncFolderPickerViewController(driveManager: driveManager)
    show(folderPicker, sender: nil)
  }
}
