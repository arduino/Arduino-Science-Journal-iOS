//  
//  OnboardingPage3ViewController.swift
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

class OnboardingPage3ViewController: OnboardingPageViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    title = String.onboarding03Title

    stackView.addArrangedSubview(
      OnboardingContainer(content: OnboardingIllustration(),
                          anchoredTo: [.top, .bottom],
                          centered: true),
      customSpacing: 48
    )
    stackView.addArrangedSubview(OnboardingHTMLText(text: String.onboarding03Text02))

    stackView.addArrangedSubview(OnboardingSpacer())
  }

}

private class OnboardingIllustration: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    let topStackView = UIStackView()
    topStackView.axis = .horizontal
    topStackView.spacing = 20
    topStackView.alignment = .center

    let addImage = OnboardingImage(imageName: "onboarding_03_01")
    addImage.setContentHuggingPriority(.required, for: .horizontal)
    topStackView.addArrangedSubview(addImage)
    
    topStackView.addArrangedSubview(
      OnboardingText(text: String.onboarding03Text01)
    )

    topStackView.widthAnchor.constraint(equalToConstant: 270).isActive = true

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 36

    stackView.addArrangedSubview(topStackView)

    let image = OnboardingImage(imageName: "onboarding_03_02")
    stackView.addArrangedSubview(image)
    
    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.pinToEdgesOfView(self)

    let connector = OnboardingConnector(edges: [.leading, .bottom])
    insertSubview(connector, at: 0)

    connector.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      connector.topAnchor.constraint(equalTo: addImage.bottomAnchor),
      connector.leadingAnchor.constraint(equalTo: addImage.centerXAnchor),
      connector.trailingAnchor.constraint(equalTo: image.centerXAnchor),
      connector.bottomAnchor.constraint(equalTo: image.centerYAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
