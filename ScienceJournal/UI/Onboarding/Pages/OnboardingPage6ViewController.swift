//  
//  OnboardingPage6ViewController.swift
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

class OnboardingPage6ViewController: OnboardingPageViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    title = String.onboarding06Title

    stackView.addArrangedSubview(OnboardingHTMLText(text: String.onboarding06Text01),
                                 customSpacing: 36)

    let image1 = OnboardingImage(imageName: "onboarding_06_01")
    image1.setContentHuggingPriority(.required, for: .horizontal)

    let image2 = OnboardingImage(imageName: "onboarding_06_02")
    image2.setContentHuggingPriority(.required, for: .horizontal)

    let image3 = OnboardingImage(imageName: "onboarding_06_03")
    image3.setContentHuggingPriority(.required, for: .horizontal)
    image3.setContentCompressionResistancePriority(.required - 1, for: .horizontal)
    
    let text1 = OnboardingHTMLText(text: String.onboarding06Text02, lineHeight: nil)
    let text2 = OnboardingHTMLText(text: String.onboarding06Text03, lineHeight: nil)

    var constraints = [NSLayoutConstraint]()

    [(image1, text1), (image2, text2)].forEach { image, text in
      let stackView = UIStackView(arrangedSubviews: [image, text])
      stackView.axis = .horizontal
      stackView.spacing = 20
      stackView.alignment = .top

      constraints.append(stackView.widthAnchor.constraint(equalTo: image3.widthAnchor, constant: -36))

      self.stackView.addArrangedSubview(
        OnboardingContainer(content: stackView,
                            anchoredTo: [.top, .bottom],
                            centered: true),
        customSpacing: 16)
    }

    stackView.addArrangedSubview(
      OnboardingContainer(content: image3,
                          anchoredTo: [.top, .bottom],
                          centered: true)
    )

    stackView.addArrangedSubview(OnboardingSpacer())

    NSLayoutConstraint.activate(constraints)
  }
}
