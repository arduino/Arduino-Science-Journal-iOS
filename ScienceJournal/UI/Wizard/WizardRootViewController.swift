//  
//  WizardRootViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 04/01/21.
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

class WizardRootViewController: UIViewController {

  var onDismiss: ((_ wizard: WizardRootViewController, _ isCancelled: Bool) -> Void)?

  var initialViewController: UIViewController? {
    didSet {
      guard isViewLoaded else { return }
      guard let viewController = initialViewController else { return }
      childNavigationController?.setViewControllers([viewController], animated: true)
    }
  }

  private var childNavigationController: UINavigationController? {
    didSet {
      oldValue?.delegate = nil
      childNavigationController?.delegate = self
    }
  }

  @IBOutlet private weak var titleView: UIView!

  @IBOutlet private weak var footerView: WizardFooterView! {
    didSet {
      footerView.clipsToBounds = false
      footerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
      footerView.layer.shadowOffset = CGSize(width: 0, height: -3)
      footerView.layer.shadowOpacity = 1
      footerView.layer.shadowRadius = 0
    }
  }

  private var titleViewVerticalConstraint: NSLayoutConstraint? {
    didSet {
      oldValue?.isActive = false
      titleViewVerticalConstraint?.isActive = true
    }
  }

  private var titleViewHeightConstraint: NSLayoutConstraint? {
    didSet {
      oldValue?.isActive = false
      titleViewHeightConstraint?.isActive = true
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let navigationBar = childNavigationController?.navigationBar {
      titleViewVerticalConstraint = titleView.centerYAnchor
        .constraint(equalTo: navigationBar.centerYAnchor)

      titleViewHeightConstraint = titleView.heightAnchor
        .constraint(lessThanOrEqualTo: navigationBar.heightAnchor, multiplier: 1, constant: -4)
    }

    if let viewController = initialViewController {
      childNavigationController?.setViewControllers([viewController], animated: true)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    footerView.layer.shadowPath = UIBezierPath(rect: footerView.bounds).cgPath
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "childNavigationController",
       let navigationController = segue.destination as? UINavigationController {
      childNavigationController = navigationController
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }

  func close() {
    onDismiss?(self, true)
  }

  @objc
  private func close(_ sender: UIBarButtonItem) {
    close()
  }

  private func createCloseButton() -> UIBarButtonItem {
    let button = UIBarButtonItem(image: UIImage(named: "navigation_close"),
                    style: .plain,
                    target: self,
                    action: #selector(close(_:)))
    return button
  }

}

extension WizardRootViewController: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController,
                            animated: Bool) {
    viewController.navigationItem.title = nil
    viewController.navigationItem.rightBarButtonItem = createCloseButton()
    viewController.view.backgroundColor = navigationController.navigationBar.barTintColor

    if let wizard = viewController as? WizardViewController {
      wizard.rootViewController = self
    }
  }
}
