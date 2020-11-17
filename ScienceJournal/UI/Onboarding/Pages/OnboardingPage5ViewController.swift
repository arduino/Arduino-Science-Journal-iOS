//  
//  OnboardingPage5ViewController.swift
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

class OnboardingPage5ViewController: OnboardingPageViewController {

    override func viewDidLoad() {
      title = String.onboarding05Title

      let image1 = OnboardingImage(imageName: "onboarding_05_01")
      image1.setContentHuggingPriority(.required, for: .horizontal)

      let image2 = OnboardingImage(imageName: "onboarding_05_02")
      image2.setContentHuggingPriority(.required, for: .horizontal)
      image2.setContentCompressionResistancePriority(.required - 1, for: .horizontal)
      
      let text = OnboardingText(text: String.onboarding05Text01)
      text.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)

      let quickTip = OnboardingQuickTip(text: String.onboarding05QuickTip)

      let topStackView = UIStackView(arrangedSubviews: [image1, text])
      topStackView.axis = .horizontal
      topStackView.spacing = 16
      topStackView.alignment = .center

      stackView.addArrangedSubview(
        OnboardingContainer(content: topStackView,
                            anchoredTo: [.top, .bottom],
                            centered: true),
        customSpacing: 50
      )
      stackView.addArrangedSubview(
        OnboardingContainer(content: image2,
                            anchoredTo: [.top, .bottom],
                            centered: true),
        customSpacing: 20
      )
      stackView.addArrangedSubview(
        OnboardingContainer(content: quickTip,
                            anchoredTo: [.top, .bottom],
                            centered: true)
      )
      stackView.addArrangedSubview(OnboardingSpacer())

      topStackView.widthAnchor.constraint(equalTo: image2.widthAnchor)
        .isActive = true
      quickTip.widthAnchor.constraint(equalTo: image2.widthAnchor, constant: -48)
        .isActive = true

      let connector = OnboardingConnector(edges: [.top, .bottom, .leading])
      scrollView.insertSubview(connector, at: 0)
      connector.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        connector.topAnchor.constraint(equalTo: image1.centerYAnchor, constant: -3),
        connector.bottomAnchor.constraint(equalTo: image2.topAnchor, constant: 69),
        connector.leadingAnchor.constraint(equalTo: image1.leadingAnchor, constant: -20),
        connector.trailingAnchor.constraint(equalTo: image1.centerXAnchor),
      ])
    }

}
