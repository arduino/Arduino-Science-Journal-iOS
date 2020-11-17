//  
//  OnboardingScrollIndicator.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 17/11/20.
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

class OnboardingScrollIndicator: UIView {
  @IBOutlet private weak var safeAreaBackgroundView: UIView!
  @IBOutlet private weak var backgroundImageView: UIImageView!
  @IBOutlet private weak var indicatorView: UIImageView!

  private var animator: UIViewPropertyAnimator?

  override func awakeFromNib() {
    super.awakeFromNib()

    safeAreaBackgroundView.backgroundColor = ArduinoColorPalette.grayPalette.tint50
    backgroundImageView.image = UIImage(named: "onboarding_scroll_indicator_bg")?.resizableImage(withCapInsets: .zero)
  }

  func startAnimation(_ reversed: Bool = false) {
    if let animator = animator, animator.isRunning {
      return
    }

    let animator = UIViewPropertyAnimator(duration: 1.25,
                                          timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
    animator.addAnimations { [weak indicatorView] in
      indicatorView?.transform =  reversed ? .identity : CGAffineTransform(translationX: 0, y: -15)
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
