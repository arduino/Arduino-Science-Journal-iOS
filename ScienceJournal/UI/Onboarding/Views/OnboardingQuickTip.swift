//  
//  OnboardingQuickTip.swift
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
                                            lineHeight: 22,
                                            layoutDirection: traitCollection.layoutDirection)

    let textContainer = UIStackView(arrangedSubviews: [header, tip])
    textContainer.axis = .vertical
    textContainer.spacing = 0

    addArrangedSubview(textContainer)
  }
}
