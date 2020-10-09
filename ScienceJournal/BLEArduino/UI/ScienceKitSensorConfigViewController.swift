//  
//  ScienceKitSensorConfigViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 16/07/2020.
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

import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialTypography
import third_party_sciencejournal_ios_ScienceJournalProtos

class ScienceKitSensorConfigViewController: ScienceJournalViewController {
  private enum Metrics {
    static let viewInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
    static let verticalViewInsets = viewInsets.top + viewInsets.bottom
    static let verticalSpacing: CGFloat = 10
  }

  var options = [BLEArduinoSensorConfig]() {
    didSet {
      typeSelector.options = options
    }
  }

  var config = BLEArduinoSensorConfig.raw {
    didSet {
      typeSelector.configType = config
    }
  }

  let okButton = MDCFlatButton()

  private let stackView = UIStackView()
  private let headerLabel = UILabel()
  private let typeSelector = ScienceKitSensorConfigSelectorView()

  /// The height required to display the view's contents depending on type selection.
  private var totalHeight: CGFloat {
    let headerHeight =
      headerLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    let okButtonHeight = okButton.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    let typeSelectorHeight =
      typeSelector.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

    let height = headerHeight + okButtonHeight + typeSelectorHeight + Metrics.verticalViewInsets
    let verticalSpaces: CGFloat = 2
    return height + Metrics.verticalSpacing * verticalSpaces
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    accessibilityViewIsModal = true

    stackView.axis = .vertical
    stackView.spacing = Metrics.verticalSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)

    headerLabel.text = String.titleActivitySensorSettings
    headerLabel.font = MDCTypography.titleFont()
    headerLabel.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(headerLabel)

    typeSelector.optionSelectorDelegate = self
    typeSelector.typeDelegate = self
    typeSelector.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(typeSelector)

    let buttonWrapper = UIView()
    buttonWrapper.translatesAutoresizingMaskIntoConstraints = false
    buttonWrapper.addSubview(okButton)
    okButton.translatesAutoresizingMaskIntoConstraints = false
    okButton.setTitleColor(.appBarReviewBackgroundColor, for: .normal)
    okButton.topAnchor.constraint(equalTo: buttonWrapper.topAnchor).isActive = true
    okButton.trailingAnchor.constraint(equalTo: buttonWrapper.trailingAnchor).isActive = true
    okButton.bottomAnchor.constraint(equalTo: buttonWrapper.bottomAnchor).isActive = true

    okButton.setTitle(String.actionOk, for: .normal)
    okButton.accessibilityHint = String.deviceOptionsOkContentDescription
    stackView.addArrangedSubview(buttonWrapper)

    stackView.pinToEdgesOfView(view)
    stackView.layoutMargins = Metrics.viewInsets
    stackView.isLayoutMarginsRelativeArrangement = true

    setPreferredContentSize()
  }

  override func accessibilityPerformEscape() -> Bool {
    dismiss(animated: true)
    return true
  }

  private func setPreferredContentSize() {
    // When presented as a Material dialog, the preferred content size dictates its displayed size.
    preferredContentSize = CGSize(width: 200, height: totalHeight)
  }
}

extension ScienceKitSensorConfigViewController: SensorConfigTypeOptionDelegate {
  func sensorConfigTypeOptionSelectionChanged() {
    config = typeSelector.configType
  }
}

extension ScienceKitSensorConfigViewController: OptionSelectorDelegate {
  func optionSelectorView(_ optionSelectorView: OptionSelectorView,
                          didPressShowOptions actions: [PopUpMenuAction],
                          coveringView: UIView) {
    // Show the actions in a pop up menu.
    let popUpMenu = PopUpMenuViewController()
    popUpMenu.addActions(actions)
    popUpMenu.present(from: self, position: .coveringView(coveringView))
  }
}
