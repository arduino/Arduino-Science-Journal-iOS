//  
//  OnboardingPageView.swift
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

class OnboardingPageView: UIView {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!

  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var scrollIndicator: OnboardingScrollIndicator!

  override func awakeFromNib() {
    super.awakeFromNib()

    backgroundColor = ArduinoColorPalette.grayPalette.tint50
    bringSubviewToFront(scrollIndicator)

    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.setCustomSpacing(20, after: titleLabel)

    titleLabel.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.Medium.rawValue)
    titleLabel.textColor = ArduinoColorPalette.grayPalette.tint700
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    updateStackViewMargins()
    updateScrollViewIndicator(animated: false)
  }

  func updateScrollViewIndicator(animated: Bool = true) {
    if !animated {
      // if not animated we are setting the initial state
      // so let's make sure content size and frames are setup
      // correctly
      UIView.performWithoutAnimation {
        self.scrollView.layoutIfNeeded()
      }
    }

    let transform: CGAffineTransform

    if scrollView.isContentOutsideOfSafeArea {
      transform = .identity
    } else {
      transform = CGAffineTransform(translationX: 0, y: scrollIndicator.frame.height)
    }

    guard transform != scrollIndicator.transform else {
      return
    }

    if animated {
      UIView.animate(withDuration: 0.2) {
        self.scrollIndicator.transform = transform
      }
    } else {
      UIView.performWithoutAnimation {
        self.scrollIndicator.transform = transform
      }
    }
  }
}

extension OnboardingPageView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateScrollViewIndicator()
  }
}

private extension OnboardingPageView {
  func updateStackViewMargins() {
    let leading = floor(bounds.width * 0.08)
    let trailing = leading
    stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16,
                                                                 leading: leading,
                                                                 bottom: 24,
                                                                 trailing: trailing)
  }
}

class OnboardingContainer: UIView {
  convenience init(content: UIView,
                   anchoredTo edges: [Edge] = [.top, .bottom],
                   width: CGFloat? = nil,
                   centered: Bool = true) {
    self.init()
    addSubview(content)
    content.translatesAutoresizingMaskIntoConstraints = false
    content.pinToEdgesOfView(self, andEdges: edges, withInsets: .zero)
    if let width = width {
      content.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    if centered {
      content.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
  }
}

class OnboardingSpacer: UIView {
  convenience init(fixed: CGFloat? = nil) {
    self.init()
    if let fixed = fixed {
      setContentCompressionResistancePriority(.required, for: .horizontal)
      setContentHuggingPriority(.required, for: .horizontal)
      widthAnchor.constraint(equalToConstant: fixed).isActive = true
    }
  }
}

class OnboardingText: UILabel {
  convenience init(htmlText: String, lineHeight: Float? = 24) {
    self.init()

    numberOfLines = 0

    let font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
    let textColor = ArduinoColorPalette.grayPalette.tint700!

    attributedText = NSAttributedString(htmlBody: text,
                                        font: font,
                                        color: textColor,
                                        lineHeight: lineHeight,
                                        layoutDirection: traitCollection.layoutDirection)
  }

  convenience init(text: String) {
    self.init()

    numberOfLines = 0

    font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
    textColor = ArduinoColorPalette.grayPalette.tint700!
    self.text = text
  }
}

class OnboardingImage: UIImageView {
  convenience init(imageName: String) {
    self.init()

    contentMode = .scaleAspectFit
    image = UIImage(named: imageName)
  }
}
