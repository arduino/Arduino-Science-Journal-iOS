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

  override func awakeFromNib() {
    super.awakeFromNib()

    backgroundColor = ArduinoColorPalette.grayPalette.tint50

    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.setCustomSpacing(20, after: titleLabel)

    titleLabel.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.Medium.rawValue)
    titleLabel.textColor = ArduinoColorPalette.grayPalette.tint700
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    updateStackViewMargins()
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

class OnboardingSpacer: UIView {}

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

class OnboardingConnector: UIView {

  var edges: [Edge] = []

  private lazy var shapeLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = ArduinoColorPalette.grayPalette.tint300?.cgColor
    shapeLayer.lineWidth = 2
    shapeLayer.lineDashPattern = [4, 4]
    return shapeLayer
  }()

  private var path: CGPath {
    let path = CGMutablePath()

    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint
    let p4: CGPoint
    if traitCollection.layoutDirection == .rightToLeft {
      p1 = CGPoint(x: bounds.width, y: 0)
      p2 = CGPoint(x: bounds.width, y: bounds.height)
      p3 = CGPoint(x: 0, y: bounds.height)
      p4 = CGPoint(x: 0, y: 0)
    } else {
      p1 = CGPoint(x: 0, y: 0)
      p2 = CGPoint(x: 0, y: bounds.height)
      p3 = CGPoint(x: bounds.width, y: bounds.height)
      p4 = CGPoint(x: bounds.width, y: 0)
    }

    path.move(to: p1)
    if edges.contains(.leading) {
      path.addLine(to: p2)
    } else {
      path.move(to: p2)
    }

    if edges.contains(.bottom) {
      path.addLine(to: p3)
    } else {
      path.move(to: p3)
    }

    if edges.contains(.trailing) {
      path.addLine(to: p4)
    } else {
      path.move(to: p4)
    }

    if edges.contains(.top) {
      path.addLine(to: p1)
    } else {
      path.move(to: p1)
    }

    return path
  }

  convenience init(edges: [Edge]) {
    self.init(frame: .zero)
    self.edges = edges
    layer.addSublayer(shapeLayer)
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    shapeLayer.frame = self.layer.bounds
    shapeLayer.path = self.path
  }
}

class OnboardingText: UILabel {
  convenience init(text: String) {
    self.init()

    numberOfLines = 0

    let font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
    let textColor = ArduinoColorPalette.grayPalette.tint700!

    attributedText = NSAttributedString(htmlBody: text,
                                        font: font,
                                        color: textColor,
                                        lineHeight: 24,
                                        layoutDirection: traitCollection.layoutDirection)
  }
}

class OnboardingImage: UIImageView {
  convenience init(imageName: String) {
    self.init()

    contentMode = .scaleAspectFit
    image = UIImage(named: imageName)
  }
}

class OnboardingButton: UIButton {
  enum Style {
    case outline
    case filled
  }

  private var style = Style.outline

  convenience init(style: Style, title: String) {
    self.init(type: .system)

    self.style = style

    contentEdgeInsets = UIEdgeInsets(top: 4, left: 28, bottom: 4, right: 28)
    setTitle(title, for: .normal)
    titleLabel?.font = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)

    updateStyle()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2.0
  }

  private func updateStyle() {
    switch style {
    case .outline:
      setTitleColor(ArduinoColorPalette.grayPalette.tint700, for: .normal)
      backgroundColor = .clear
      layer.borderWidth = 1.5
      layer.borderColor = ArduinoColorPalette.grayPalette.tint700?.cgColor
    case .filled:
      setTitleColor(.white, for: .normal)
      backgroundColor = ArduinoColorPalette.tealPalette.tint800
      layer.borderWidth = 0
      layer.borderColor = nil
    }
  }
}

class OnboardingQuickTip: UIStackView {
  convenience init(text: String) {
    self.init()
    axis = .horizontal
    spacing = 16

    let segment = UIView()
    segment.translatesAutoresizingMaskIntoConstraints = false
    segment.widthAnchor.constraint(equalToConstant: 6).isActive = true
    segment.backgroundColor = ArduinoColorPalette.tealPalette.tint600

    addArrangedSubview(segment)

    let header = UILabel()
    header.numberOfLines = 1
    header.text = String.onboardingQuickTipHeader
    header.font = ArduinoTypography.monoBoldFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
    header.textColor = ArduinoColorPalette.grayPalette.tint700

    let tipFont = ArduinoTypography.monoRegularFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
    let tipColor = ArduinoColorPalette.grayPalette.tint700!

    let tip = UILabel()
    tip.numberOfLines = 0
    tip.attributedText = NSAttributedString(htmlBody: text,
                                            font: tipFont,
                                            color: tipColor,
                                            lineHeight: 24,
                                            layoutDirection: traitCollection.layoutDirection)

    let textContainer = UIStackView(arrangedSubviews: [header, tip])
    textContainer.axis = .vertical
    textContainer.spacing = 0

    addArrangedSubview(textContainer)
  }
}
