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

protocol PDFExportOverlayViewControllerDelegate: class {
  /// The PDF export process should be canceled.
  func pdfExportShouldCancel()
}

/// A view controller with a Material header used when rendering a PDF.
final class PDFExportOverlayViewController: MaterialHeaderViewController {

  public weak var delegate: PDFExportOverlayViewControllerDelegate?

  let progressView = MaterialFloatingSpinner()
  let titleLabel = UILabel()
  let wrappingStackView = UIStackView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
    view.accessibilityViewIsModal = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if UIAccessibility.isVoiceOverRunning {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        // Delay the announcement until a moment after the view appears to ensure it doesn't
        // get interrupted by the cancel button's announcement.
        UIAccessibility.post(notification: UIAccessibility.Notification.announcement,
                             argument: String.exportPdfModalTitle)
      }
    }
  }

  override func accessibilityPerformEscape() -> Bool {
    cancelButtonPressed()
    return true
  }

}

private extension PDFExportOverlayViewController {

  struct Metrics {
    static let stackViewSpacing: CGFloat = 10
    static let titleLabelFont = MDCTypography.titleFont()
  }

  func setupSubviews() {
    let cancelItem = UIBarButtonItem(title: String.actionCancel,
                                     style: .plain,
                                     target: self,
                                     action: #selector(cancelButtonPressed))
    navigationItem.leftBarButtonItem = cancelItem

    titleLabel.font = Metrics.titleLabelFont
    titleLabel.text = String.exportPdfModalTitle

    progressView.isHidden = false
    progressView.indicatorMode = .indeterminate
    progressView.startAnimating()

    view.addSubview(wrappingStackView)
    wrappingStackView.addArrangedSubview(titleLabel)
    wrappingStackView.addArrangedSubview(progressView)
    wrappingStackView.axis = .vertical
    wrappingStackView.alignment = .center
    wrappingStackView.spacing = Metrics.stackViewSpacing
    wrappingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    wrappingStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }

  @objc private func cancelButtonPressed() {
    delegate?.pdfExportShouldCancel()
  }

}
