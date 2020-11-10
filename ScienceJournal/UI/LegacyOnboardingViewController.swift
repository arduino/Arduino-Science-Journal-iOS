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

/// The base class for onboarding view controllers that contains the Science Journal colors,
/// iconography and layout. Permissions and welcome screens should subclass this to adhere to the
/// designed look for initial flows.
class LegacyOnboardingViewController: ScienceJournalViewController {

  // MARK: - Properties

  enum Metrics {
    static let outerPaddingNarrow: CGFloat = 24.0
    static let outerPaddingWide: CGFloat = 100.0
    static let maxLabelWidth: CGFloat = 400.0
    static let compassXOffset: CGFloat = -10.0
    static let compassYOffset: CGFloat = 8.0
    static let logoYOffset: CGFloat = 40.0
    static let magGlassXOffset: CGFloat = 26.0
    static let magGlassYOffset: CGFloat = 10.0
    static let pencilXOffset: CGFloat = 28.0
    static let pencilYOffset: CGFloat = -120.0
    static let rulerXOffset: CGFloat = -40.0
    static let rulerYOffset: CGFloat = -140.0
    static let innerSpacing: CGFloat = 20.0
    static let buttonSpacing: CGFloat = 60.0
    static let buttonSpacingInner: CGFloat = 8.0
    static let buttonSpacingWide: CGFloat = 30.0
    static let padWidth: CGFloat = 540.0
    static let padHeight: CGFloat = 620.0
    static let compassImageOffsetX: CGFloat = 145
    static let compassImageOffsetY: CGFloat = 34
    static let magGlassImageOffsetX: CGFloat = -145
    static let magGlassImageOffsetY: CGFloat = 63
    static let pencilImageOffsetX: CGFloat = -145
    static let pencilImageOffsetY: CGFloat = -102
    static let rulerImageOffsetX: CGFloat = 145
    static let rulerImageOffsetY: CGFloat = -100
    static let backgroundColor = UIColor.white
    static let backgroundTransparent = UIColor(red: 0.290, green: 0.078, blue: 0.549, alpha: 0.0)
    static let gradientHeight: CGFloat = 200.0
    static let bodyFont = ArduinoTypography.regularFont(forSize: 16)
    static let headerHeightCompactRegular: CGFloat = 162
    static let headerHeightCompactCompact: CGFloat = 0
    static let headerHeightRegularRegular: CGFloat = 260
  }

  /// The header image, part of the splash montage.
  let headerImage = UIImageView(image: UIImage(named: "guide_header"))

  // MARK: Public

  /// A wrapping view used to constrain the view to a specific size on iPad. On other devices, this
  /// will be the same size as `view`. All subviews should be added to this view.
  let wrappingView = UIView()

  /// When laying out the wrapping view, it will be centered vertically when true. Otherwise, it is
  /// full screen on iPhone and a standard height on iPad. The wrapping view height must be properly
  /// sized for this to work. Defaults to false.
  var shouldCenterWrappingViewVertically = false {
    didSet {
      configureVariableConstraints(forTraitCollection: traitCollection)
    }
  }

  private var wrappingViewConstraints = [NSLayoutConstraint]()
  private var headerHeightConstraint: NSLayoutConstraint?

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: - Public

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureVariableConstraints(forTraitCollection: traitCollection)
  }

  override func willTransition(to newCollection: UITraitCollection,
                               with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    configureVariableConstraints(forTraitCollection: newCollection)
  }

  func configureView() {
    view.backgroundColor = Metrics.backgroundColor

    // Configure the wrapping view.
    view.addSubview(wrappingView)
    wrappingView.translatesAutoresizingMaskIntoConstraints = false

    // Various parts of the splash montage.
    headerImage.clipsToBounds = true
    headerImage.contentMode = .scaleAspectFill
    wrappingView.addSubview(headerImage)
    headerImage.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 11.0, *) {
      headerImage.accessibilityIgnoresInvertColors = true
    }
  }

  // Configures constraints to position the header image at the top of the view.
  func configureHeaderImagePinnedToTop() {
    // Lay out the header.
    let headerHeightConstraint =
      headerImage.bottomAnchor.constraint(equalTo: wrappingView.safeAreaLayoutGuide.topAnchor,
                                          constant: 162)

    NSLayoutConstraint.activate([
      headerImage.trailingAnchor.constraint(equalTo: wrappingView.trailingAnchor,
                                            constant: 0),
      headerImage.leadingAnchor.constraint(equalTo: wrappingView.leadingAnchor,
                                           constant: 0),
      headerImage.topAnchor.constraint(equalTo: wrappingView.topAnchor,
                                       constant: 0),
      headerHeightConstraint
    ])

    self.headerHeightConstraint = headerHeightConstraint
  }

  // MARK: - Private

  private func configureVariableConstraints(
      forTraitCollection newTraitCollection: UITraitCollection) {
    view.removeConstraints(wrappingViewConstraints)
    wrappingViewConstraints.removeAll()

    wrappingViewConstraints.append(
      wrappingView.topAnchor.constraint(equalTo: view.topAnchor))
    wrappingViewConstraints.append(
      wrappingView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
    wrappingViewConstraints.append(
      wrappingView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
    wrappingViewConstraints.append(
      wrappingView.bottomAnchor.constraint(equalTo: view.bottomAnchor))

    NSLayoutConstraint.activate(wrappingViewConstraints)

    if newTraitCollection.verticalSizeClass == .compact {
      headerHeightConstraint?.constant = Metrics.headerHeightCompactCompact
    } else if newTraitCollection.horizontalSizeClass == .regular {
      headerHeightConstraint?.constant = Metrics.headerHeightRegularRegular
    } else {
      headerHeightConstraint?.constant = Metrics.headerHeightCompactRegular
    }
  }

}
