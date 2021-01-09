//  
//  DriveSyncFolderPickerViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 07/01/21.
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

class DriveSyncFolderPickerViewController: WizardViewController {

  let driveManager: DriveManager

  let selectButton = WizardButton(title: String.driveSyncFolderPickerSelect, isSolid: true)

  private(set) lazy var pickerView = DriveSyncFolderPickerView()

  private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                             navigationOrientation: .horizontal,
                                                             options: nil)
  
  init(driveManager: DriveManager) {
    self.driveManager = driveManager
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    wizardView.title = String.driveSyncFolderPickerTitle
    wizardView.text = String.driveSyncFolderPickerText

    addContentView()
    addPageViewController()
    addSelectButton()
  }

  override func show(_ vc: UIViewController, sender: Any?) {
    if vc is DriveSyncFolderListTableViewController {
      pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    } else {
      super.show(vc, sender: sender)
    }
  }
  
  private func addContentView() {
    wizardView.hasFixedHeight = true
    wizardView.contentView = pickerView
  }

  private func addSelectButton() {
    view.addSubview(selectButton)
    selectButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      selectButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
      selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
    ])
  }

  private func addPageViewController() {
    addChild(pageViewController)
    pickerView.pageView.addSubview(pageViewController.view)
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    pageViewController.view.pinToEdgesOfView(pickerView.pageView)
    pageViewController.didMove(toParent: self)

    pageViewController.setViewControllers([
      DriveSyncFolderListTableViewController(driveManager: driveManager, folder: nil, selectButton: selectButton)
    ], direction: .forward, animated: false, completion: nil)
  }
}
