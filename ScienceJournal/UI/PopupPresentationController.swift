//  
//  PopupPresentationController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 16/04/21.
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

protocol PopupPresentationControllerDelegate: class {
  func popupPresentationController(_ popupPresentationController: PopupPresentationController,
                                   didDismiss viewController: UIViewController)
}

class PopupPresentationController: UIPresentationController {
  
  weak var popupDelegate: PopupPresentationControllerDelegate?
  
  private lazy var dimmingView: UIView = {
    let dimmingView = UIView()
    dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView(_:)))
    dimmingView.addGestureRecognizer(tap)
    
    return dimmingView
  }()
  
  private var bottomInset: CGFloat = 0
  
  private func layoutPresentedView() {
    var frame = frameOfPresentedViewInContainerView
      .applying(CGAffineTransform(translationX: 0, y: -bottomInset))
    
    let originY = frame.origin.y
    if originY < 0 {
      frame.origin.y = 0
      frame.size.height += originY
    }
    
    presentedView?.frame = frame
  }
  
  @objc
  private func didTapDimmingView(_ sender: UITapGestureRecognizer) {
    if sender.state == .ended {
      presentingViewController.dismiss(animated: true, completion: nil)
    }
  }
}

// MARK:- Overrides
extension PopupPresentationController {
  override func presentationTransitionWillBegin() {
    guard let containerView = containerView else {
      return
    }
    
    dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    dimmingView.frame = containerView.bounds
    containerView.insertSubview(dimmingView, at: 0)
    
    guard let coordinator = presentedViewController.transitionCoordinator else {
      return
    }
    
    dimmingView.alpha = 0
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 1.0
    })
    
    presentedView?.layer.cornerRadius = 5
    presentedView?.clipsToBounds = true
  }
  
  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0.0
    })
  }
  
  override func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed {
      popupDelegate?.popupPresentationController(self, didDismiss: presentedViewController)
    }
  }
  
  override func size(forChildContentContainer container: UIContentContainer,
                     withParentContainerSize parentSize: CGSize) -> CGSize {
    let width = min(min(parentSize.width, parentSize.height) - 60, 500)
    return CGSize(width: width,
                  height: min(container.preferredContentSize.height, parentSize.height))
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = containerView else {
      return .zero
    }
    
    let bounds = containerView.bounds
    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController,
                      withParentContainerSize: bounds.size)
    frame.origin = CGPoint(x: (bounds.width - frame.width) / 2.0, y: (bounds.height - frame.height) / 2.0)
    
    return frame
  }
  
  override func containerViewWillLayoutSubviews() {
    layoutPresentedView()
  }
  
  override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
    layoutPresentedView()
  }
}
