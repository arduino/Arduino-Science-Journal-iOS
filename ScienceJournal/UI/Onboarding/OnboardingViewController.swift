//  
//  OnboardingViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 10/11/2020.
//  Copyright © 2020 Arduino. All rights reserved.
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

class OnboardingViewController: UIViewController {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var titleLabel: UILabel!

  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupTopBar()
  }
}

private extension OnboardingViewController {
  func setupView() {
    view.backgroundColor = ArduinoColorPalette.grayPalette.tint50
  }

  func setupTopBar() {
    topBar.backgroundColor = ArduinoColorPalette.goldPalette.tint400

    titleLabel.textColor = UIColor.white
    titleLabel.font = ArduinoTypography.monoBoldFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    titleLabel.attributedText = NSAttributedString(string: String.onboardingNavigationTitle,
                                                   attributes: [.kern: 2])
  }
}
