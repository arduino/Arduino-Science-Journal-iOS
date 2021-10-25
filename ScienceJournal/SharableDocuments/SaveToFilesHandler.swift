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
import MaterialComponents.MaterialDialogs

/// Handles saving experiments, trial data and images to the Files app.
class SaveToFilesHandler: NSObject, UIDocumentPickerDelegate {

  /// Indicates the result of the user action taken in the file picker.
  enum SaveToFilesResult {
    /// The file was saved.
    case saved
    /// The file picker was cancelled.
    case cancelled
  }

  /// The completion called when save to files completes. Called with the save to files result.
  typealias SaveToFilesCompletion = (SaveToFilesResult) -> Void

  private var completion: SaveToFilesCompletion?
  private var documentPicker: UIDocumentPickerViewController?

  /// Presents the save to files browser for a URL.
  ///
  /// - Parameters:
  ///   - url: The url of the file to save.
  ///   - presentingViewController: A view controller to present the save to files VC.
  ///   - completion: Called when complete.
  func presentSaveToFiles(for url: URL,
                          from presentingViewController: UIViewController,
                          completion: @escaping SaveToFilesCompletion) {
    self.completion = completion
    let documentPicker = UIDocumentPickerViewController(url: url, in: .exportToService)
    self.documentPicker = documentPicker
    documentPicker.delegate = self
    if UIDevice.current.userInterfaceIdiom == .pad {
      documentPicker.modalPresentationStyle = .formSheet
    }
    presentingViewController.present(documentPicker, animated: true, completion: nil)
  }

  /// Presents the save to files browser for an experiment.
  ///
  /// - Parameters:
  ///   - experiment: The experiment to save.
  ///   - documentManager: The document manager.
  ///   - presentingViewController: A view controller to present the save to files VC.
  func presentSaveToFiles(forExperiment experiment: Experiment,
                          documentManager: DocumentManager,
                          presentingViewController: UIViewController) {
    let spinnerViewController = SpinnerViewController()

    func saveExperimentToFiles() {
      documentManager.createExportDocument(forExperimentWithID: experiment.ID) { url in
        spinnerViewController.dismissSpinner {
          guard let url = url else {
            // The export failed, show an error message.
            showSnackbar(withMessage: String.saveToFilesSingleErrorMessage)
            return
          }

          self.presentSaveToFiles(for: url,
                                  from: presentingViewController) { result in
            switch result {
            case .saved:
              showSnackbar(withMessage: String.saveToFilesSingleSuccessMessage)
            case .cancelled:
              break
            }
            documentManager.finishedWithExportDocument(atURL: url)
          }
        }
      }
    }

    spinnerViewController.present(fromViewController: presentingViewController) {
      documentManager.experimentIsReadyForExport(experiment) { isReady in
        if isReady {
          saveExperimentToFiles()
        } else {
          spinnerViewController.dismissSpinner {
            let alertController =
                MDCAlertController(title: String.experimentNotFinishedDownloadingTitle,
                                   message: String.experimentNotFinishedDownloadingMessage)
            let cancelAction = MDCAlertAction(title: String.actionCancel)
            let okAction =
                MDCAlertAction(title: String.experimentNotFinishedDownloadingConfirmButton) { _ in
              saveExperimentToFiles()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            alertController.accessibilityViewIsModal = true
            if let cancelButton = alertController.button(for: cancelAction),
               let okButton = alertController.button(for: okAction) {
              alertController.styleAlertCancel(button: cancelButton)
              alertController.styleAlertOk(button: okButton)
            }
            presentingViewController.present(alertController, animated: true)
          }
        }
      }
    }
  }

  // MARK: - Private

  private func handleDocumentPicked() {
    completion?(.saved)
    completion = nil
    documentPicker = nil
  }

  // MARK: - UIDocumentPickerDelegate

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    completion?(.cancelled)
    completion = nil
    documentPicker = nil
  }

  func documentPicker(_ controller: UIDocumentPickerViewController,
                      didPickDocumentsAt urls: [URL]) {
    handleDocumentPicked()
  }

  // Needed for iOS 10 support. When it is no longer supported, this can be removed.
  func documentPicker(_ controller: UIDocumentPickerViewController,
                      didPickDocumentAt url: URL) {
    handleDocumentPicked()
  }

}
