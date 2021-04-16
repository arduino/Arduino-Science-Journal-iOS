//  
//  ClaimOnboardingViewController.swift
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

class ClaimOnboardingViewController: StackViewController {

  let displayName: String
  
  private lazy var titleLabel = OnboardingText(text: String.claimExperimentOnboardingTitle)
  private lazy var text1Label =
    OnboardingHTMLText(text: String(format: String.claimExperimentOnboardingText1, displayName))
  private lazy var text2Label = OnboardingHTMLText(text: String.claimExperimentOnboardingText2)
  
  private lazy var hint1Image = UIImage(named: "ic_add_to_drive")?.withRenderingMode(.alwaysTemplate)
  private lazy var hint2Image = UIImage(named: "ic_export")?.withRenderingMode(.alwaysTemplate)
  private lazy var hint3Image = UIImage(named: "ic_delete")?.withRenderingMode(.alwaysTemplate)
  
  private lazy var hint1ImageView = UIImageView(image: hint1Image)
  private lazy var hint2ImageView = UIImageView(image: hint2Image)
  private lazy var hint3ImageView = UIImageView(image: hint3Image)
  
  private lazy var hintFont = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
  
  private lazy var hint1Label =
    OnboardingHTMLText(text: String(format: String.claimExperimentOnboardingHint1, displayName),
                       lineHeight: 0,
                       font: hintFont)
  private lazy var hint2Label = OnboardingHTMLText(text: String.claimExperimentOnboardingHint2,
                                                   lineHeight: 0,
                                                   font: hintFont)
  private lazy var hint3Label = OnboardingHTMLText(text: String.claimExperimentOnboardingHint3,
                                                   lineHeight: 0,
                                                   font: hintFont)
  
  private lazy var button = WizardButton(title: String.claimExperimentOnboardingButton,
                                         style: .solid,
                                         size: .regular)
  
  private lazy var hintsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    
    let rows = [
      (hint1ImageView, hint1Label),
      (hint2ImageView, hint2Label),
      (hint3ImageView, hint3Label)
    ].map { (image, text) -> UIStackView in
      image.setContentCompressionResistancePriority(.required, for: .horizontal)
      image.setContentCompressionResistancePriority(.required, for: .vertical)
      image.setContentHuggingPriority(.required, for: .vertical)
      image.contentMode = .scaleAspectFit
      image.widthAnchor.constraint(equalToConstant: 54).isActive = true
      image.tintColor = ArduinoColorPalette.grayPalette.tint900
      
      text.numberOfLines = 0
      text.setContentCompressionResistancePriority(.required, for: .vertical)
      text.setContentCompressionResistancePriority(.required, for: .horizontal)
      
      let stackView = UIStackView(arrangedSubviews: [image, text])
      stackView.axis = .horizontal
      stackView.alignment = .center
      stackView.spacing = 0
      return stackView
    }
    
    rows.forEach { stackView.addArrangedSubview($0) }
    
    return stackView
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  
  init(displayName: String) {
    self.displayName = displayName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    stackView.layoutMargins = UIEdgeInsets(top: 23, left: 20, bottom: 23, right: 20)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.alignment = .fill
    stackView.spacing = 20
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(text1Label)
    stackView.addArrangedSubview(text2Label)
    stackView.addArrangedSubview(hintsStackView)
    stackView.addArrangedSubview(OnboardingContainer(content: button))
    
    super.viewDidLoad()
    
    view.backgroundColor = .white
    button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
  }
  
  @objc private func dismiss(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
