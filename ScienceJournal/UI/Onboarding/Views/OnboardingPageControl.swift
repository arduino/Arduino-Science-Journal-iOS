//  
//  OnboardingPageControl.swift
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

class OnboardingPageControl: UIStackView {

  var numberOfPages: Int = 0 {
    didSet {
      guard numberOfPages != oldValue else { return }
      updateNumberOfPages()
    }
  }

  var currentPage: Int = 0 {
    didSet {
      guard currentPage != oldValue else { return }
      updateCurrentPage()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupView()
  }

  required init(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    setupView()
  }

  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    size.height = 2
    return size
  }

  private func setupView() {
    backgroundColor = .clear
    axis = .horizontal
    spacing = 3
    alignment = .fill
    distribution = .fillEqually
  }

  private func updateNumberOfPages() {
    removeAllArrangedViews()

    for _ in 0..<numberOfPages {
      let view = UIView()
      addArrangedSubview(view)
    }

    updateCurrentPage()
  }

  private func updateCurrentPage() {
    for i in 0..<numberOfPages {
      let segment = arrangedSubviews[i]
      if i <= currentPage {
        segment.backgroundColor = .white
      } else {
        segment.backgroundColor = UIColor(white: 1, alpha: 0.4)
      }
    }
  }
}
