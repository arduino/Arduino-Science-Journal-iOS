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
import third_party_objective_c_material_components_ios_components_ActionSheet_ActionSheet

/// Handles file type selection in the process of exporting documents.
class FileTypeSelectionHandler: NSObject {

  /// Indicates the result of the user action taken in the action sheet.
  enum FileTypeSelectionResult {
    /// PDF type selected.
    case pdf
    /// SJ type selected.
    case sj
  }

  typealias FileTypeSelectionCompletion = (FileTypeSelectionResult) -> Void

  /// Presents the file type selection sheet.
  ///
  /// - Parameters:
  ///   - viewController: A view controller to present from.
  ///   - completion: Called when complete.
  func showFileTypeSelection(from viewController: UIViewController,
                             exportType: UserExportType,
                             completion: @escaping FileTypeSelectionCompletion) {
    var pdfTitle: String {
      switch exportType {
      case .saveToFiles:
        return String.actionSavePdf
      case .share:
        return String.actionSharePdf
      }
    }

    var sjTitle: String {
      switch exportType {
      case .saveToFiles:
        return String.actionSaveSj
      case .share:
        return String.actionShareSj
      }
    }

    let pdfAction =
      MDCActionSheetAction(title: pdfTitle,
                           image: UIImage(named: "ic_drive_pdf")) { _ in completion(.pdf) }
    let sjAction =
      MDCActionSheetAction(title: sjTitle,
                           image: UIImage(named: "ic_sj_file")) { _ in completion(.sj) }

    let actionSheet = MDCActionSheetController()
    actionSheet.addAction(pdfAction)
    actionSheet.addAction(sjAction)
    viewController.present(actionSheet, animated: true)
  }

}
