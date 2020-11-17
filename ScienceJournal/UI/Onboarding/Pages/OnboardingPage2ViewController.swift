//  
//  OnboardingPage2ViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 12/11/2020.
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

class OnboardingPage2ViewController: OnboardingPageViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    title = String.onboarding02Title

    stackView.addArrangedSubview(OnboardingHTMLText(text: String.onboarding02Text01), customSpacing: 28)

    let image = OnboardingImage(imageName: "onboarding_02")
    stackView.addArrangedSubview(image, customSpacing: 16)

    let quickTip = OnboardingQuickTip(text: String.onboarding02QuickTip)
    stackView.addArrangedSubview(
      OnboardingContainer(content: quickTip,
                          anchoredTo: [.top, .bottom],
                          centered: true)
    )

    quickTip.widthAnchor.constraint(equalTo: image.widthAnchor, constant: -48)
      .isActive = true

    stackView.addArrangedSubview(OnboardingSpacer())
  }

}
