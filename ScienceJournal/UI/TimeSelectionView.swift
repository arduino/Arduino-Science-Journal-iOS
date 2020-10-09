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

/// A view that displays a timestamp and a confirm button. Used when editing a note's timestamp.
class TimeSelectionView: ShadowedView {

  // MARK: - Properties

  /// Whether or not to show the confirm button.
  var shouldShowConfirmButton: Bool = true {
    didSet {
      // Set alpha instead of `isHidden`, because the height of the confirm button is what is
      // setting the overall height of the stack view.
      confirmButton.alpha = shouldShowConfirmButton ? 1 : 0
    }
  }

  private let clockIcon = UIImageView()
  let timestampLabel = UILabel()
  let confirmButton = MDCFlatButton()

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
    backgroundColor = .white
    layer.cornerRadius = 2

    clockIcon.image = UIImage(named: "ic_access_time")
    clockIcon.tintColor = ArduinoColorPalette.grayPalette.tint500
    clockIcon.translatesAutoresizingMaskIntoConstraints = false
    clockIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    timestampLabel.font = MDCTypography.fontLoader().regularFont(ofSize: 12)
    timestampLabel.translatesAutoresizingMaskIntoConstraints = false

    confirmButton.setImage(UIImage(named: "ic_check_circle"), for: .normal)
    confirmButton.tintColor = ArduinoColorPalette.tealPalette.tint800
    confirmButton.translatesAutoresizingMaskIntoConstraints = false
    confirmButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    confirmButton.accessibilityLabel = String.saveBtnContentDescription

    let stackView = UIStackView(arrangedSubviews: [clockIcon, timestampLabel, confirmButton])
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    stackView.pinToEdgesOfView(self,
                               withInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
  }

}
