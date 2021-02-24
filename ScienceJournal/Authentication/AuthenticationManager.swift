//  
//  AuthenticationManager.swift
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
import GoogleSignIn

public struct User {
  var googleUser: GIDGoogleUser

  init?(googleUser: GIDGoogleUser?) {
    guard let user = googleUser else { return nil }
    self.googleUser = user
  }
}

public class AuthenticationManager: NSObject {

  var isAuthenticated: Bool {
    (try? _authenticatedUser.value()) != nil
  }

  var authenticatedUser: User? { try? _authenticatedUser.value() }

  private lazy var _authenticatedUser = BehaviorSubject<User?>(value: nil)

  private var _googleSignIn: PublishSubject<User>?

  public init(googleClientID: String = Bundle.googleClientID) {
    super.init()
    GIDSignIn.sharedInstance()?.clientID = googleClientID
    GIDSignIn.sharedInstance()?.delegate = self
  }

  public func signIn(with account: Account, from viewController: UIViewController) -> Observable<User> {
    switch account {
    case .arduino: return .error(Error.notImplemented)
    case .google: return signInWithGoogle(from: viewController)
    }
  }
  
  public func restorePreviousSignIn() -> Bool {
    GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    return isAuthenticated
  }

  public func signOut(from account: Account) throws {
    switch account {
    case .arduino: throw Error.notImplemented
    case .google: signOutFromGoogle()
    }
  }

  public func accessToken(for account: Account) throws -> String {
    switch account {
    case .arduino: throw Error.notImplemented
    case .google:
      guard let token = GIDSignIn.sharedInstance()?
              .currentUser?
              .authentication?
              .accessToken else {
        throw Error.notAuthenticated
      }
      return token
    }
  }
}

// MARK:- Google
extension AuthenticationManager {
  public var googleScopes: [String] {
    get {
      return GIDSignIn.sharedInstance()?.scopes as? [String] ?? []
    }
    set {
      GIDSignIn.sharedInstance()?.scopes = newValue
    }
  }

  public var googleGrantedScopes: [String] {
    GIDSignIn.sharedInstance()?.currentUser.grantedScopes as? [String] ?? []
  }
}

public extension AuthenticationManager {
  enum Account {
    case arduino
    case google
  }

  enum Error: Swift.Error {
    case notImplemented
    case notAuthenticated
    case alreadyAuthenticating
  }
}

private extension AuthenticationManager {
  func signInWithGoogle(from presentingViewController: UIViewController) -> Observable<User> {
    if _googleSignIn != nil {
      return .error(Error.alreadyAuthenticating)
    }

    guard let authenticator = GIDSignIn.sharedInstance() else {
      return .error(Error.notImplemented)
    }

    authenticator.presentingViewController = presentingViewController
    authenticator.signIn()

    let observable = PublishSubject<User>()
    _googleSignIn = observable
    return observable
  }

  func signOutFromGoogle() {
    GIDSignIn.sharedInstance()?.signOut()
    _authenticatedUser.onNext(nil)
  }
}

extension AuthenticationManager: GIDSignInDelegate {
  public func sign(_ signIn: GIDSignIn!,
                   didSignInFor user: GIDGoogleUser!,
                   withError error: Swift.Error!) {
    let user = User(googleUser: user)

    if let error = error {
      if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
        print("The user has not signed in before or they have since signed out.")
      } else {
        print("\(error.localizedDescription)")
      }
      _googleSignIn?.onError(error)
    } else if let user = user {
      _authenticatedUser.onNext(user)
      _googleSignIn?.onNext(user)
      _googleSignIn?.onCompleted()
    } else {
      _googleSignIn?.onError(Error.notAuthenticated)
    }

    _googleSignIn = nil
  }

  public func sign(_ signIn: GIDSignIn!,
                   didDisconnectWith user: GIDGoogleUser!,
                   withError error: Swift.Error!) {
    if error == nil {
      _authenticatedUser.onNext(nil)
    }
  }
}
