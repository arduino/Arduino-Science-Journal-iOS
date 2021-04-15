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

import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialPalettes
import MaterialComponents.MaterialTypography

protocol ClaimExperimentsViewDelegate: class {
  /// Tells the delegate the user pressed the claim experiments button.
  func claimExperimentsViewDidPressClaimExperiments()
}

/// A view used to show a button that allows a user to claim experiments that don't belong to an
/// account.
class ClaimExperimentsView: UIView {

  // MARK: - Properties

  weak var delegate: ClaimExperimentsViewDelegate?

  private let descriptionLabel = UILabel()
  private let claimButton = WizardButton(title: String.claimExperimentsButtonTitle,
                                         style: .system,
                                         size: .regular)

  // MARK: - Public

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureView()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    // Shadow
    clipsToBounds = false
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
  }

  /// Sets the number of unclaimed experiments to display.
  ///
  /// - Parameter number: The number of unclaimed experiments.
  func setNumberOfUnclaimedExperiments(_ number: Int) {
    if number == 1 {
      descriptionLabel.text = String.claimExperimentsDescriptionWithCountOne
    } else {
      descriptionLabel.text = String(format: String.claimExperimentsDescriptionWithCount, number)
    }
    setNeedsLayout()
  }

  // MARK: - Private

  private func configureView() {
    backgroundColor = .white
    
    // Shadow
    layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
    layer.shadowRadius = 6
    layer.shadowOffset = CGSize(width: 0, height: 3)
    layer.shadowOpacity = 1
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 14
    stackView.layoutMargins = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    stackView.pinToEdgesOfView(self)
    
    // Description label
    descriptionLabel.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XXSmall.rawValue)
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = ArduinoColorPalette.grayPalette.tint700
    stackView.addArrangedSubview(descriptionLabel)

    // Claim button
    claimButton.addTarget(self,
                          action: #selector(claimButtonPressed),
                          for: .touchUpInside)
    claimButton.setContentHuggingPriority(.required, for: .horizontal)
    stackView.addArrangedSubview(claimButton)
  }

  // MARK: - User actions

  @objc func claimButtonPressed() {
    delegate?.claimExperimentsViewDidPressClaimExperiments()
  }

}

/// The claim experiments view wrapped in a UICollectionReusableView, so it can be displayed as a
/// collection view header without being full width.
class ClaimExperimentsHeaderView: UICollectionReusableView {

  // MARK: - Properties

  /// The claim experiments view.
  let claimExperimentsView = ClaimExperimentsView()

  // MARK: - Public

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureView()
  }

  // MARK: - Private

  private func configureView() {
    addSubview(claimExperimentsView)
    claimExperimentsView.translatesAutoresizingMaskIntoConstraints = false
    claimExperimentsView.pinToEdgesOfView(self)
  }
}
