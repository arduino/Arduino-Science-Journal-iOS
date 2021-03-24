//
//  KeyboardController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 24/03/21.
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

class KeyboardController {
  let scrollView: UIScrollView
  
  private let keyboardObserver = KeyboardObserver.shared
  
  init(scrollView: UIScrollView) {
    self.scrollView = scrollView
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleKeyboardNotification(_:)),
                                           name: .keyboardObserverWillShow,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleKeyboardNotification(_:)),
                                           name: .keyboardObserverWillHide,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleKeyboardNotification(_:)),
                                           name: .keyboardObserverWillChangeFrame,
                                           object: nil)
  }
  
  private lazy var defaultContentInsets: UIEdgeInsets = self.scrollView.contentInset
  private lazy var defaultScrollIndicatorInsets: UIEdgeInsets = self.scrollView.verticalScrollIndicatorInsets
  
  @objc private func handleKeyboardNotification(_ notification: Notification) {
    guard let duration = KeyboardObserver.animationDuration(fromKeyboardNotification: notification),
          let rawCurve = KeyboardObserver.animationCurve(fromKeyboardNotification: notification)?.rawValue,
          let animationCurve = UIView.AnimationCurve(rawValue: Int(rawCurve)) else { return }
    animate(withDuration: duration, animationCurve: animationCurve)
  }
  
  private func animate(withDuration duration: TimeInterval,
                       animationCurve: UIView.AnimationCurve) {
    let animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve) {
      self.handleKeyboard(rect: self.keyboardObserver.currentKeyboardFrame)
    }
    animator.startAnimation()
  }
  
  private func handleKeyboard(rect: CGRect?) {
    guard let superview = scrollView.superview else { return }
    
    guard let keyboardFrame = rect else {
      scrollView.contentInset.bottom = defaultContentInsets.bottom
      scrollView.verticalScrollIndicatorInsets.bottom = defaultScrollIndicatorInsets.bottom
      return
    }
    
    let intersection = scrollView.bounds.intersection(scrollView.convert(keyboardFrame, from: nil))
    
    scrollView.contentInset.bottom = defaultContentInsets.bottom + intersection.height
    scrollView.verticalScrollIndicatorInsets.bottom = defaultScrollIndicatorInsets.bottom + intersection.height
    
    if scrollView.frame.maxY >= superview.bounds.height - superview.safeAreaInsets.bottom {
      scrollView.verticalScrollIndicatorInsets.bottom -= superview.safeAreaInsets.bottom
    }
  }
}
