//  
//  ArduinoAccountsManager.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 04/02/21.
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
import googlemac_iPhone_Shared_SSOAuth_SSOAuth
import GTMSessionFetcher

public class ArduinoAccount: AuthAccount {
  public var ID: String
  public var email: String
  public var displayName: String
  public var profileImage: UIImage?
  public var isShareRestricted: Bool
  public var authorization: GTMFetcherAuthorizationProtocol?
  
  init(ID: String,
       email: String,
       displayName: String,
       profileImage: UIImage?,
       isShareRestricted: Bool,
       authorization: GTMFetcherAuthorizationProtocol?) {
  
    self.ID = ID
    self.email = email
    self.displayName = displayName
    self.profileImage = profileImage
    self.isShareRestricted = isShareRestricted
    self.authorization = authorization
  }
}

final class ArduinoAccountsManager: AccountsManager {
  
  let authenticationManager: AuthenticationManager
  
  weak var delegate: AccountsManagerDelegate?
  
  var supportsAccounts: Bool { true }
  
  var currentAccount: AuthAccount? {
    guard let user = authenticationManager.authenticatedUser else {
      return nil
    }
    
    let account = ArduinoAccount(ID: user.googleUser.userID,
                                 email: user.googleUser.profile.email,
                                 displayName: user.googleUser.profile.name,
                                 profileImage: nil,
                                 isShareRestricted: false,
                                 authorization: user.googleUser.authentication.fetcherAuthorizer())
    return account
  }
  
  private lazy var disposeBag = DisposeBag()
  
  init(authenticationManager: AuthenticationManager) {
    self.authenticationManager = authenticationManager
  }
  
  func signInAsCurrentAccount() {
    if authenticationManager.restorePreviousSignIn() {
      delegate?.accountsManagerDidSignIn(signInType: .restoreCachedAccount)
    }
  }
  
  func signOutCurrentAccount() {
    NotificationCenter.default.post(name: .userWillBeSignedOut, object: self)
    try? authenticationManager.signOut(from: .google)
    delegate?.accountsManagerDidSignOut()
  }
  
  func presentSignIn(fromViewController viewController: UIViewController) {
    presentSignIn(from: viewController)
  }
  
  func reauthenticateCurrentAccount() -> Bool {
    return false
  }
  
  func removeLingeringAccounts() {
    
  }
}

private extension ArduinoAccountsManager {
  func presentSignIn(from viewController: UIViewController, completion: (() -> Void)? = nil) {
    guard let wizardViewController = UIStoryboard(name: "Wizard", bundle: nil).instantiateInitialViewController()
            as? WizardRootViewController else { return }
    wizardViewController.initialViewController = DriveSyncIntroViewController(authenticationManager: authenticationManager)
    wizardViewController.onDismiss = { [weak self] wizard, isCancelled in
      wizard.dismiss(animated: true, completion: nil)
      if !isCancelled {
        self?.delegate?.accountsManagerDidSignIn(signInType: .newSignIn)
      }
    }
    if viewController.traitCollection.userInterfaceIdiom == .pad {
      wizardViewController.modalPresentationStyle = .formSheet
    } else {
      wizardViewController.modalPresentationStyle = .fullScreen
    }
    
    if let presentedViewController = viewController.presentedViewController {
      presentedViewController.dismiss(animated: true) {
        viewController.present(wizardViewController, animated: true, completion: nil)
      }
    } else {
      viewController.present(wizardViewController, animated: true, completion: nil)
    }
  }
}
