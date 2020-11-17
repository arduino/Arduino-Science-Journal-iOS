//  
//  OnboardingPage7ViewController.swift
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

class OnboardingPage7ViewController: OnboardingPageViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    title = String.onboarding07Title

    let image1 = OnboardingImage(imageName: "onboarding_07_01")
    image1.setContentHuggingPriority(.required, for: .horizontal)

    let image2 = OnboardingImage(imageName: "onboarding_07_02")
    image2.setContentHuggingPriority(.required, for: .horizontal)
    image2.setContentCompressionResistancePriority(.required - 1, for: .horizontal)

    let text1 = OnboardingHTMLText(text: String.onboarding07Text01, lineHeight: 24)

    let textContainer = UIStackView(arrangedSubviews: [image1, text1])
    textContainer.axis = .horizontal
    textContainer.spacing = 20
    textContainer.alignment = .center

    stackView.addArrangedSubview(
      OnboardingContainer(content: textContainer,
                          anchoredTo: [.top, .bottom],
                          centered: true),
      customSpacing: 80)

    stackView.addArrangedSubview(
      OnboardingContainer(content: image2,
                          anchoredTo: [.top, .bottom],
                          centered: true),
      customSpacing: 28
    )

    stackView.addArrangedSubview(OnboardingSpacer())

    let button = OnboardingButton(style: .filled,
                                  size: .large,
                                  title: String.onboardingFinishButton)
    button.addTarget(self, action: #selector(finish(_:)), for: .touchUpInside)

    stackView.addArrangedSubview(
      OnboardingContainer(content: button),
      customSpacing: 20
    )

    textContainer.widthAnchor.constraint(equalTo: image2.widthAnchor).isActive = true

    let connector = OnboardingPolylineConnector()
    scrollView.insertSubview(connector, at: 0)
    connector.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      connector.topAnchor.constraint(equalTo: image1.bottomAnchor, constant: 20),
      connector.bottomAnchor.constraint(equalTo: image2.topAnchor, constant: 10),
      connector.leadingAnchor.constraint(equalTo: image1.centerXAnchor),
      connector.trailingAnchor.constraint(equalTo: image2.trailingAnchor, constant: -70),
    ])
  }

  @objc
  private func finish(_ sender: UIButton) {
    onPrimaryAction?()
  }
}
