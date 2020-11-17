//  
//  OnboardingPage1ViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 11/11/2020.
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

class OnboardingPage1ViewController: OnboardingPageViewController {

  var navigationHint: OnboardingNavigationHint?

  override func viewDidLoad() {
    super.viewDidLoad()

    title = String.onboarding01Title

    stackView.addArrangedSubview(OnboardingImage(imageName: "onboarding_01"), customSpacing: 32)
    stackView.addArrangedSubview(OnboardingHTMLText(text: String.onboarding01Text01), customSpacing: 28)
    stackView.addArrangedSubview(
      OnboardingContainer(content: OnboardingQuickTip(text: String.onboarding01QuickTip),
                          anchoredTo: [.top, .bottom, .leading],
                          width: 260,
                          centered: false),
      customSpacing: 28
    )
    stackView.addArrangedSubview(OnboardingSpacer())

    let button = OnboardingButton(style: .outline,
                                  title: String.onboardingSkipButton)
    button.addTarget(self, action: #selector(skip(_:)), for: .touchUpInside)

    stackView.addArrangedSubview(
      OnboardingContainer(content: button),
      customSpacing: 20
    )

    let navigationHint = OnboardingNavigationHint()
    stackView.addArrangedSubview(
      OnboardingContainer(content: navigationHint,
                          anchoredTo: [.top, .bottom],
                          centered: true)
    )

    self.navigationHint = navigationHint
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // let's wait a little bit before starting the animation
    // otherwise it won't run properly
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
      self.navigationHint?.startAnimation()
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.navigationHint?.stopAnimation()
  }

  @objc
  private func skip(_ sender: UIButton) {
    onPrimaryAction?()
  }
}

class OnboardingNavigationHint: UIStackView {

  private var arrow: UIView?
  private var animator: UIViewPropertyAnimator?

  init() {
    super.init(frame: .zero)
    backgroundColor = .clear
    axis = .horizontal
    spacing = 2

    let hintFont = ArduinoTypography.monoRegularFont(forSize: 10)
    let hintColor = ArduinoColorPalette.secondaryLabelColor

    let hint = UILabel()
    hint.numberOfLines = 1
    hint.attributedText = NSAttributedString(htmlBody: String.onboardingNavigationHint,
                                             font: hintFont,
                                             color: hintColor,
                                             lineHeight: 8,
                                             layoutDirection: traitCollection.layoutDirection)

    let image = UIImageView(image: UIImage(named: "onboarding_hint"))
    image.setContentCompressionResistancePriority(.required, for: .horizontal)
    image.setContentCompressionResistancePriority(.required, for: .vertical)
    image.setContentHuggingPriority(.required, for: .horizontal)
    image.setContentHuggingPriority(.required, for: .vertical)
    arrow = image

    addArrangedSubview(image)
    addArrangedSubview(hint)
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

  func startAnimation(_ reversed: Bool = false) {
    if let animator = animator, animator.isRunning {
      return
    }

    let animator = UIViewPropertyAnimator(duration: 1.25,
                                          timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
    animator.addAnimations { [weak arrow] in
      arrow?.transform =  reversed ? .identity : CGAffineTransform(translationX: -15, y: 0)
    }
    animator.addCompletion { [weak self] _ in
      self?.animator = nil
      self?.startAnimation(!reversed)
    }
    animator.startAnimation()

    self.animator = animator
  }

  func stopAnimation() {
    animator?.stopAnimation(true)
  }
}
