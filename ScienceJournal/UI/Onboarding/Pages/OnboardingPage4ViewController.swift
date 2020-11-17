//  
//  OnboardingPage4ViewController.swift
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

class OnboardingPage4ViewController: OnboardingPageViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    title = String.onboarding04Title

    stackView.addArrangedSubview(
      OnboardingContainer(content: OnboardingIllustration(),
                          anchoredTo: [.top, .bottom],
                          centered: true),
      customSpacing: 57
    )
    stackView.addArrangedSubview(OnboardingHTMLText(text: String.onboarding04Text05))

    stackView.addArrangedSubview(OnboardingSpacer())
  }

}

private class OnboardingIllustration: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 0

    let text1 = OnboardingText(text: String.onboarding04Text01)
    let text2 = OnboardingText(text: String.onboarding04Text02)

    let text3 = OnboardingText(text: String.onboarding04Text03)
    text3.textAlignment = .right

    let text4 = OnboardingText(text: String.onboarding04Text04)
    text4.textAlignment = .right

    let image = OnboardingImage(imageName: "onboarding_04")
    image.setContentHuggingPriority(.required, for: .horizontal)
    image.setContentHuggingPriority(.required, for: .vertical)
    image.setContentCompressionResistancePriority(.required, for: .horizontal)
    image.setContentCompressionResistancePriority(.required, for: .vertical)

    stackView.addArrangedSubview(UIStackView(arrangedSubviews: [
                                              OnboardingSpacer(fixed: 64),
                                              text1,
                                              OnboardingSpacer()]))

    stackView.addArrangedSubview(UIStackView(arrangedSubviews: [
                                              OnboardingSpacer(),
                                              text2,
                                              OnboardingSpacer(fixed: 8)]),
                                 customSpacing: 22)

    stackView.addArrangedSubview(
      OnboardingContainer(content: image,
                          anchoredTo: [.top, .bottom, .leading, .trailing]),
      customSpacing: 40
    )

    stackView.addArrangedSubview(UIStackView(arrangedSubviews: [
                                              text3,
                                              OnboardingSpacer()]))

    stackView.addArrangedSubview(UIStackView(arrangedSubviews: [
                                              OnboardingSpacer(),
                                              text4,
                                              OnboardingSpacer(fixed: 64)]))

    [text1, text2, text3, text4].forEach {
      $0.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.pinToEdgesOfView(self)

    let connector1 = OnboardingConnector(edges: [.leading, .top])
    insertSubview(connector1, at: 0)
    connector1.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      connector1.topAnchor.constraint(equalTo: text1.centerYAnchor),
      connector1.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 44),
      connector1.trailingAnchor.constraint(equalTo: text1.leadingAnchor, constant: -8),
      connector1.bottomAnchor.constraint(equalTo: image.centerYAnchor)
    ])

    let connector2 = OnboardingConnector(edges: [.leading, .top])
    insertSubview(connector2, at: 0)
    connector2.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      connector2.topAnchor.constraint(equalTo: text2.centerYAnchor),
      connector2.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 44 + 128 + 40),
      connector2.trailingAnchor.constraint(equalTo: text2.leadingAnchor, constant: -8),
      connector2.bottomAnchor.constraint(equalTo: image.centerYAnchor)
    ])

    let connector3 = OnboardingConnector(edges: [.trailing, .bottom])
    insertSubview(connector3, at: 0)
    connector3.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      connector3.topAnchor.constraint(equalTo: image.centerYAnchor),
      connector3.leadingAnchor.constraint(equalTo: text3.trailingAnchor, constant: 8),
      connector3.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: 44 + 44 + 40),
      connector3.bottomAnchor.constraint(equalTo: text3.centerYAnchor)
    ])

    let connector4 = OnboardingConnector(edges: [.trailing, .bottom])
    insertSubview(connector4, at: 0)
    connector4.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      connector4.topAnchor.constraint(equalTo: image.centerYAnchor),
      connector4.leadingAnchor.constraint(equalTo: text4.trailingAnchor, constant: 8),
      connector4.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: 44 + 212 + 40),
      connector4.bottomAnchor.constraint(equalTo: text4.centerYAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
