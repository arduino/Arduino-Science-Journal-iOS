//  
//  OnboardingConnector.swift
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

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    shapeLayer.path = self.path
  }
}

class OnboardingPolylineConnector: UIView {

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
      p2 = CGPoint(x: bounds.width, y: bounds.height / 2.0)
      p3 = CGPoint(x: 0, y: bounds.height / 2.0)
      p4 = CGPoint(x: 0, y: bounds.height)
    } else {
      p1 = CGPoint(x: 0, y: 0)
      p2 = CGPoint(x: 0, y: bounds.height / 2.0)
      p3 = CGPoint(x: bounds.width, y: bounds.height / 2.0)
      p4 = CGPoint(x: bounds.width, y: bounds.height)
    }

    path.move(to: p1)
    path.addLine(to: p2)
    path.addLine(to: p3)
    path.addLine(to: p4)

    return path
  }

  init() {
    super.init(frame: .zero)
    layer.addSublayer(shapeLayer)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)
    shapeLayer.frame = self.layer.bounds
    shapeLayer.path = self.path
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    shapeLayer.path = self.path
  }
}
