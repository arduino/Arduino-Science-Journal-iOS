//  
//  TermsAgreementViewController.swift
//  ScienceJournal
//
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
import GoogleSignIn
import GoogleAPIClientForREST
import MaterialComponents.MaterialDialogs

class TermsAgreementViewController: UIViewController {
  
   private(set) lazy var termsAgreementView = TermsAgreementView()

  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.addSubview(termsAgreementView)

    termsAgreementView.translatesAutoresizingMaskIntoConstraints = false
    termsAgreementView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    termsAgreementView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

    let titleText = "Terms and Conditions"

    let titleAttributedString = NSMutableAttributedString(string: titleText)
    titleAttributedString.addAttribute(NSAttributedString.Key.font,
    value: ArduinoTypography.boldFont(forSize: 20), range: NSRange(location: 0, length: titleAttributedString.length))
    titleAttributedString.addAttribute(NSAttributedString.Key.foregroundColor,
    value: ArduinoColorPalette.tealPalette.tint800, range: NSRange(location: 0, length: titleAttributedString.length))

    termsAgreementView.title.attributedText = titleAttributedString

    let labelText = "We have updated the app Terms and Conditions. By tapping here you indicate" +
      "that you have read and agree to the new Terms presented in the agreement"

    let labelAttributedString = NSMutableAttributedString(string: labelText)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 8
    paragraphStyle.alignment = .center
    labelAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
    value: paragraphStyle, range: NSRange(location: 0, length: labelAttributedString.length))
    labelAttributedString.addAttribute(NSAttributedString.Key.font,
    value: ArduinoTypography.regularFont(forSize: 16), range: NSRange(location: 0, length: labelAttributedString.length))

    termsAgreementView.label.attributedText = labelAttributedString

    termsAgreementView.acceptButton.setTitle("Accept", for: .normal)
    termsAgreementView.acceptButton.setTitleColor(UIColor.white, for: .normal)
    termsAgreementView.acceptButton.contentHorizontalAlignment = .center

    termsAgreementView.acceptButton.addTarget(self,
                 action: #selector(acceptTerms),
                 for: .touchUpInside)

  }

  @objc private func acceptTerms() {
    UserDefaults.standard.set(true, forKey: "termsAccepted")
    self.dismiss(animated: true)
  }

}
