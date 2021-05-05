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
import MaterialComponents.MaterialPalettes
import MaterialComponents.MaterialTextFields

protocol EditExperimentViewControllerDelegate: class {
  /// Informs the delegate a new title was set.
  ///
  /// - Parameters:
  ///   - title: A string title.
  ///   - experimentID: The ID of the changed experiment.
  func editExperimentViewControllerDidSetTitle(_ title: String?,
                                               forExperimentID experimentID: String)

  /// Informs the delegate a new cover image was set.
  ///
  /// - Parameters:
  ///   - imageData: The cover image data.
  ///   - metadata: The image metadata.
  ///   - experimentID: The ID of the changed experiment.
  func editExperimentViewControllerDidSetCoverImageData(_ imageData: Data?,
                                                        metadata: NSDictionary?,
                                                        forExperimentID experimentID: String)
}

/// A view allowing a user to edit an experiment's title and picture.
class EditExperimentViewController: MaterialHeaderViewController, EditExperimentPhotoViewDelegate,
                                    ImageSelectorDelegate, UITextFieldDelegate {

  // MARK: - Constants

  let verticalPadding: CGFloat = 16.0

  // MARK: - Properties

  weak var delegate: EditExperimentViewControllerDelegate?

  private let experiment: Experiment
  private let metadataManager: MetadataManager
  private let photoPicker = EditExperimentPhotoView()
  private let scrollView = UIScrollView()
  private let textField = MDCTextField()
  private var textFieldController: MDCTextInputController?
  private var existingTitle: String?
  private var existingPhoto: UIImage?
  private var selectedImageInfo: (imageData: Data, metadata: NSDictionary?)?

  private var textFieldLeadingConstraint: NSLayoutConstraint?
  private var textFieldTrailingConstraint: NSLayoutConstraint?
  private var textFieldWidthConstraint: NSLayoutConstraint?

  private var horizontalPadding: CGFloat {
    var padding: CGFloat {
      switch displayType {
      case .compact, .compactWide:
        return 16.0
      case .regular:
        return 100
      case .regularWide:
        return 300
      }
    }
    return padding + view.safeAreaInsetsOrZero.left + view.safeAreaInsetsOrZero.right
  }

  override var trackedScrollView: UIScrollView? {
    return scrollView
  }

  // MARK: - Public

  /// Designated initializer.
  ///
  /// - Parameters:
  ///   - experiment: An experiment.
  ///   - analyticsReporter: The analytics reporter.
  ///   - metadataManager: The metadata manager.
  init(experiment: Experiment,
       analyticsReporter: AnalyticsReporter,
       metadataManager: MetadataManager) {
    self.experiment = experiment
    self.metadataManager = metadataManager
    super.init(analyticsReporter: analyticsReporter)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(red: 0.937, green: 0.933, blue: 0.933, alpha: 1.0)

    accessibilityViewIsModal = true

    if isPresented && UIDevice.current.userInterfaceIdiom == .pad {
      appBar.hideStatusBarOverlay()
    }

    // Configure the nav bar.
    title = String.editExperimentTitle

    let cancelButton = MaterialCloseBarButtonItem(target: self,
                                                  action: #selector(cancelButtonPressed))
    navigationItem.leftBarButtonItem = cancelButton

    let saveBarButton = MaterialBarButtonItem()
    saveBarButton.button.addTarget(self,
                                   action: #selector(saveButtonPressed),
                                   for: .touchUpInside)
    saveBarButton.button.setImage(UIImage(named: "ic_check"), for: .normal)
    saveBarButton.accessibilityLabel = String.saveBtnContentDescription
    navigationItem.rightBarButtonItem = saveBarButton

    // Configure the scroll view.
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.pinToEdgesOfView(view)

    // Bring the app bar to the front.
    view.bringSubviewToFront(appBar.headerViewController.headerView)

    // Text field and its controller.
    scrollView.addSubview(textField)
    textField.delegate = self
    textField.font = ArduinoTypography.paragraphFont
    textField.text = experiment.title
    existingTitle = experiment.title
    textField.clearButtonMode = .whileEditing
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = String.experimentTitleHint
    textField.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                   constant: verticalPadding).isActive = true
    textFieldLeadingConstraint =
        textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
    textFieldLeadingConstraint?.isActive = true
    textFieldTrailingConstraint =
        textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
    textFieldTrailingConstraint?.isActive = true
    textFieldWidthConstraint =
        textField.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    textFieldWidthConstraint?.isActive = true

    let controller = MDCTextInputControllerUnderline(textInput: textField)
    controller.floatingPlaceholderNormalColor = ArduinoColorPalette.labelColor
    controller.floatingPlaceholderActiveColor = ArduinoColorPalette.labelColor    
    controller.activeColor = .appBarReviewBackgroundColor
    textFieldController = controller

    // Photo picker.
    scrollView.addSubview(photoPicker)
    photoPicker.delegate = self
    photoPicker.translatesAutoresizingMaskIntoConstraints = false
    photoPicker.setContentHuggingPriority(.defaultHigh, for: .vertical)
    photoPicker.topAnchor.constraint(equalTo: textField.bottomAnchor,
                                     constant: verticalPadding).isActive = true
    photoPicker.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                        constant: -verticalPadding).isActive = true

    photoPicker.leadingAnchor.constraint(equalTo: textField.leadingAnchor).isActive = true
    photoPicker.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true

    // Set the photo if one exists.
    if let image = metadataManager.imageForExperiment(experiment) {
      photoPicker.photo = image
      existingPhoto = image
    }

    NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleKeyboardNotification(_:)),
        name: UIResponder.keyboardDidChangeFrameNotification,
        object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateConstraintsForDisplayType()
  }

  override func viewWillTransition(to size: CGSize,
                                   with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { (_) in
      self.updateConstraintsForDisplayType()
    })
  }

  override func viewSafeAreaInsetsDidChange() {
    updateConstraintsForDisplayType()
  }

  override func accessibilityPerformEscape() -> Bool {
    guard existingTitle != trimmedTitleOrDefault() || photoPicker.photo != existingPhoto else {
      dismiss(animated: true)
      return true
    }
    // If changes need to be saved, ask the user first.
    cancelButtonPressed()
    return false
  }

  // MARK: - EditExperimentPhotoViewDelegate

  func choosePhotoButtonPressed() {
    let photoLibrary =
        EditExperimentPhotoLibraryViewController(analyticsReporter: analyticsReporter)
    photoLibrary.delegate = self
    present(photoLibrary, animated: true)
  }

  // MARK: - ImageSelectorDelegate

  func imageSelectorDidCreateImageData(_ imageDatas: [ImageData]) {
    // Check if the photo can be saved before proceeding. Normally this happens lower in the stack
    // but we do it here because it is currently not possible to pass the error up the UI to here.
    guard let imageDataTuple = imageDatas.first else {
      sjlog_info("[EditExperimentViewController] No imageData in imageSelectorDidCreateImageData.",
                 category: .general)
      return
    }

    if imageDatas.count > 1 {
      sjlog_info("[EditExperimentViewController] More than 1 ImageData.", category: .general)
    }

    if metadataManager.canSave(imageDataTuple.imageData) {
      guard let image = UIImage(data: imageDataTuple.imageData) else { return }
      photoPicker.photo = image
      selectedImageInfo = imageDataTuple
    } else {
      dismiss(animated: true) {
        showSnackbar(withMessage: String.photoDiskSpaceErrorMessage)
      }
    }
  }

  func imageSelectorDidCancel() {}

  // MARK: - Notifications

  @objc func handleKeyboardNotification(_ notification: Notification) {
    let keyboardHeight = MDCKeyboardWatcher.shared().visibleKeyboardHeight
    scrollView.contentInset.bottom = keyboardHeight
    scrollView.scrollIndicatorInsets = scrollView.contentInset
  }

  // MARK: - Private

  /// Trims the text field's text of all whitespace and returns it if it's not empty. Otherwise it
  /// returns the default untitled experiment name.
  private func trimmedTitleOrDefault() -> String {
    if let title = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), title != "" {
      return title
    }
    return String.localizedUntitledExperiment
  }

  private func updateConstraintsForDisplayType() {
    textFieldLeadingConstraint?.constant = horizontalPadding
    textFieldTrailingConstraint?.constant = -horizontalPadding
    textFieldWidthConstraint?.constant = -(horizontalPadding * 2)
  }

  // MARK: - User actions

  @objc private func cancelButtonPressed() {
    guard existingTitle != trimmedTitleOrDefault() || photoPicker.photo != existingPhoto else {
      dismiss(animated: true)
      return
    }

    // Prompt the user to save changes.
    let alertController =
        MDCAlertController(title: String.editExperimentUnsavedChangesDialogTitle,
                           message: String.editExperimentUnsavedChangesDialogMessage)
    let saveAction = MDCAlertAction(title: String.btnEditExperimentSaveChanges) { _ in
      self.saveButtonPressed()
    }
    let deleteAction =
        MDCAlertAction(title: String.btnEditExperimentDiscardChanges) { _ in
      self.dismiss(animated: true)
    }
    alertController.addAction(saveAction)
    alertController.addAction(deleteAction)
    if let cancelButton = alertController.button(for: deleteAction),
       let okButton = alertController.button(for: saveAction) {
      alertController.styleAlertCancel(button: cancelButton)
      alertController.styleAlertOk(button: okButton)
    }
    present(alertController, animated: true)
  }

  @objc private func saveButtonPressed() {
    if experiment.title != trimmedTitleOrDefault() {
      delegate?.editExperimentViewControllerDidSetTitle(trimmedTitleOrDefault(),
                                                        forExperimentID: experiment.ID)
    }

    // Only save a new cover image if the photo changed.
    if existingPhoto != photoPicker.photo {
      if let (imageData, metadata) = selectedImageInfo {
        delegate?.editExperimentViewControllerDidSetCoverImageData(imageData,
                                                                   metadata: metadata,
                                                                   forExperimentID: experiment.ID)
      } else {
        delegate?.editExperimentViewControllerDidSetCoverImageData(nil,
                                                                   metadata: nil,
                                                                   forExperimentID: experiment.ID)
      }
    }

    dismiss(animated: true)
  }

}
