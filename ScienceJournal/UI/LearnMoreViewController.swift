/*
 *  Copyright 2019 Google LLC. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import UIKit

import MaterialComponents.MaterialTypography

/// A view controller that displays the "Learn More" content about a particular sensor.
class LearnMoreViewController: MaterialHeaderViewController {

  // MARK: - Properties

  override var trackedScrollView: UIScrollView? { return scrollView }

  private let sensor: Sensor
  private let scrollView = UIScrollView()

  // MARK: - Public

  init(sensor: Sensor, analyticsReporter: AnalyticsReporter) {
    self.sensor = sensor
    super.init(analyticsReporter: analyticsReporter)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    accessibilityViewIsModal = true

    if isPresented && UIDevice.current.userInterfaceIdiom == .pad {
      appBar.hideStatusBarOverlay()
    }

    title = sensor.name

    let backMenuItem = MaterialCloseBarButtonItem(target: self,
                                                  action: #selector(backButtonPressed))
    backMenuItem.accessibilityLabel = String.closeBtnContentDescription
    navigationItem.leftBarButtonItem = backMenuItem

    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.pinToEdgesOfView(view)

    // A label configured for showing paragraph text.
    var paragraphLabel: UILabel {
      let paragraphLabel = UILabel()
      paragraphLabel.alpha = MDCTypography.body1FontOpacity()
      paragraphLabel.font = ArduinoTypography.paragraphFont
      paragraphLabel.numberOfLines = 0
      return paragraphLabel
    }

    let descriptionLabel = paragraphLabel
    descriptionLabel.text = sensor.textDescription

    let whatsGoingOnLabel = UILabel()    
    whatsGoingOnLabel.font = ArduinoTypography.headingFont
    whatsGoingOnLabel.text = String.headingInfoSection

    let firstParagraphLabel = paragraphLabel
    firstParagraphLabel.text = sensor.learnMore?.firstParagraph

    var image: UIImage? {
      guard let imageName = sensor.learnMore?.imageName else { return nil }
      return UIImage(named: imageName)
    }
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    if #available(iOS 11.0, *) {
      imageView.accessibilityIgnoresInvertColors = true
    }

    let secondParagraphLabel = paragraphLabel
    secondParagraphLabel.text = sensor.learnMore?.secondParagraph

    let stackView = UIStackView(arrangedSubviews:
        [descriptionLabel, whatsGoingOnLabel, firstParagraphLabel, imageView, secondParagraphLabel])
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    stackView.spacing = 16
    stackView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(stackView)
    stackView.pinToEdgesOfView(scrollView)
    stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

    if sensor.learnMore == nil || sensor.learnMore!.isEmpty {
      whatsGoingOnLabel.isHidden = true
    }
  }

  override func accessibilityPerformEscape() -> Bool {
    dismiss(animated: true)
    return true
  }

  // MARK: - User Actions

  @objc private func backButtonPressed() {
    dismiss(animated: true)
  }

}

extension Sensor.LearnMore {
  var isEmpty: Bool {
    firstParagraph.isEmpty && secondParagraph.isEmpty && imageName.isEmpty
  }
}
