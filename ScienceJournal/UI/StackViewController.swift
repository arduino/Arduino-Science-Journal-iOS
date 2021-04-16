//  
//  StackViewController.swift
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

class StackViewController: UIViewController {
  
  let scrollView = UIScrollView()
  let stackView = UIStackView()
  
  override func loadView() {
    stackView.axis = .vertical
    
    scrollView.delaysContentTouches = false
    scrollView.addSubview(stackView)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.pinToEdgesOfLayoutGuide(scrollView.contentLayoutGuide)
    stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1.0)
      .isActive = true
    
    view = scrollView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshPreferredContentSize()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    refreshPreferredContentSize()
    
    if let scrollView = view as? UIScrollView {
      let boundsHeight = scrollView.frame.height
        - scrollView.adjustedContentInset.top
        - scrollView.adjustedContentInset.bottom
      scrollView.isScrollEnabled = scrollView.contentSize.height > boundsHeight
    }
  }
  
  func centerContent() {
    let heightConstraint = stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1.0)
    heightConstraint.priority = .required - 1
    heightConstraint.isActive = true
    
    let topView = UIView()
    let bottomView = UIView()
    stackView.insertArrangedSubview(topView, at: 0)
    stackView.addArrangedSubview(bottomView)
    
    topView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 1.0)
      .isActive = true
  }
  
  private func refreshPreferredContentSize() {
    let targetSize = CGSize(width: view.bounds.width,
                            height: UIView.layoutFittingCompressedSize.height)
    preferredContentSize = stackView.systemLayoutSizeFitting(targetSize,
                                                             withHorizontalFittingPriority: .required,
                                                             verticalFittingPriority: .defaultLow)
  }
}
