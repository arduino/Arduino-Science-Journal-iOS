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

import AVFoundation
import Photos
import UIKit

import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialPalettes
import MaterialComponents.MaterialTypography

protocol PermissionsGuideDelegate: class {
  /// Informs the delegate the guide was completed and should be closed.
  func permissionsGuideDidComplete(_ viewController: PermissionsGuideViewController)
}

// swiftlint:disable type_body_length
/// An animated, multi-step guide to walk the user through granting Science Journal all the various
/// permissions needed.
class PermissionsGuideViewController: LegacyOnboardingViewController {

  enum Metrics {
    static let headerTopPaddingNarrow: CGFloat = 34.0
    static let headerTopPaddingNarrowSmallScreen: CGFloat = 80.0
    static let headerTopPaddingWide: CGFloat = 40.0
    static let headerTopPaddingWideSmallScreen: CGFloat = 20.0
    static let individualMessageTopPaddingNarrow: CGFloat = 80.0
    static let individualMessageTopPaddingNarrowSmallScreen: CGFloat = 60.0
    static let individualMessageTopPaddingWide: CGFloat = 40.0
    static let individualMessageTopPaddingWideSmallScreen: CGFloat = 20.0
    static let checkPadding: CGFloat = 6.0
    static let doneYOffset: CGFloat = 10.0
    static let continueYOffset: CGFloat = 10.0
    static let arduinoLogoBottomPadding: CGFloat = 30.0
    static let buttonHeight: CGFloat = 44.0
    static let buttonWidth: CGFloat = 220.0
  }

  // MARK: - Properties

  private weak var delegate: PermissionsGuideDelegate?
  private let headerTitle = UILabel()
  private let initialMessage = UILabel()
  private let finalMessage = UILabel()
  private let notificationsMessage = UILabel()
  private let microphoneMessage = UILabel()
  private let cameraMessage = UILabel()
  private let photoLibraryMessage = UILabel()
  private let completeButton = UIButton(type: .system)
  private let continueButton = UIButton(type: .system)
  private let startButton = UIButton(type: .system)
  private let logoImageView = UIImageView(image: UIImage(named: "arduino_education_logo"))
  private let stepsImageView = UIImageView()
  private let stepHeader = UIStackView()
  private let stepIcon = UIImageView()
  private let stepTitle = UILabel()
  private let devicePreferenceManager: DevicePreferenceManager

  // Used to store label constrains that will be modified on rotation.
  private var labelLeadingConstraints = [NSLayoutConstraint]()
  private var labelTrailingConstraints = [NSLayoutConstraint]()
  private var headerTopConstraint: NSLayoutConstraint?
  private var continueTopConstraint: NSLayoutConstraint?

  // The duration to animate the permission check button in.
  private var permissionCheckDuration: TimeInterval {
    return UIAccessibility.isVoiceOverRunning ? 0.3 : 0
  }

  // The interval to wait before moving to the next step.
  private var nextStepDelayInterval: TimeInterval {
    return UIAccessibility.isVoiceOverRunning ? 0.8 : 0.5
  }

  // Steps in order.
  private var steps = [stepNotifications, stepMicrophone, stepCamera, stepPhotoLibrary]

  private let showWelcomeView: Bool

  // MARK: - Public

  /// Designated initializer.
  ///
  /// - Parameters:
  ///   - delegate: The permissions guide delegate.
  ///   - analyticsReporter: The analytics reporter.
  ///   - devicePreferenceManager: The device preference manager.
  ///   - showWelcomeView: Whether to show the welcome view first.
  init(delegate: PermissionsGuideDelegate,
       analyticsReporter: AnalyticsReporter,
       devicePreferenceManager: DevicePreferenceManager,
       showWelcomeView: Bool) {
    self.delegate = delegate
    self.devicePreferenceManager = devicePreferenceManager
    self.showWelcomeView = showWelcomeView
    super.init(analyticsReporter: analyticsReporter)

    NotificationCenter.default.addObserver(
        self,
        selector: #selector(notificationRegistrationComplete),
        name: LocalNotificationManager.PushNotificationRegistrationComplete,
        object: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureView()
    if showWelcomeView {
      stepWelcome()
    } else {
      performNextStep()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateConstraintsForSize(view.bounds.size)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // If a user sees this VC, we consider them to have completed the permissions guide. This
    // is because there are certain types of permissions we cannot check the state of without
    // popping, which means it would be difficult to show/hide only the permissions they need.
    // Therefore, we mark them complete once they start, and we ask for permissions in key places
    // of the app just in case.
    devicePreferenceManager.hasAUserCompletedPermissionsGuide = true
  }

  override func viewWillTransition(to size: CGSize,
                                   with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { (_) in
      self.updateConstraintsForSize(size)
      self.view.layoutIfNeeded()
    })
  }

  // MARK: - Private

  override func configureView() {
    super.configureView()

    configureHeaderImagePinnedToTop()

    // Arduino logo.
    configureArduinoLogo()

    // Step header.
    configureStepHeader()

    // Header label.
    wrappingView.addSubview(headerTitle)
    headerTitle.translatesAutoresizingMaskIntoConstraints = false
    headerTopConstraint = headerTitle.topAnchor.constraint(equalTo: headerImage.bottomAnchor,
                                                           constant: Metrics.headerTopPaddingNarrow)
    headerTopConstraint?.priority = .defaultHigh
    headerTopConstraint?.isActive = true

    headerTitle.textColor = ArduinoColorPalette.goldPalette.tint400
    headerTitle.font = ArduinoTypography.boldFont(forSize: 28)
    headerTitle.textAlignment = .center
    headerTitle.text = String.permissionsGuideWelcomeTitle.localizedUppercase
    headerTitle.numberOfLines = 0
    headerTitle.leadingAnchor.constraint(equalTo: wrappingView.readableContentGuide.leadingAnchor).isActive = true
    headerTitle.trailingAnchor.constraint(equalTo: wrappingView.readableContentGuide.trailingAnchor).isActive = true
    headerTitle.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: headerImage.bottomAnchor,
                                     multiplier: 1).isActive = true

    // Shared label config.
    [initialMessage, finalMessage, notificationsMessage, microphoneMessage, cameraMessage,
         photoLibraryMessage].forEach {
      wrappingView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      labelLeadingConstraints.append(
        $0.leadingAnchor.constraint(equalTo: wrappingView.readableContentGuide.leadingAnchor))
      labelTrailingConstraints.append(
        $0.trailingAnchor.constraint(equalTo: wrappingView.readableContentGuide.trailingAnchor))
      $0.font = Metrics.bodyFont
      $0.textColor = ArduinoColorPalette.grayPalette.tint800
      $0.alpha = 0
      $0.numberOfLines = 0
      $0.textAlignment = .natural
      $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
    }

    initialMessage.textAlignment = .center

    NSLayoutConstraint.activate(labelLeadingConstraints)
    NSLayoutConstraint.activate(labelTrailingConstraints)

    // Initial into message and final message.
    initialMessage.alpha = 1
    initialMessage.text = String.permissionsGuideMessageIntro
    initialMessage.topAnchor.constraint(equalTo: headerTitle.bottomAnchor,
                                        constant: Metrics.innerSpacing).isActive = true

    finalMessage.text = String.permissionsGuideAllDoneMessage
    finalMessage.topAnchor.constraint(equalToSystemSpacingBelow: stepHeader.bottomAnchor, multiplier: 1).isActive = true

    // Individual messages.
    notificationsMessage.text = String.permissionsGuideNotificationsInfo
    microphoneMessage.text = String.permissionsGuideMicrophoneInfo
    cameraMessage.text = String.permissionsGuideCameraInfo
    photoLibraryMessage.text = String.permissionsGuidePhotoLibraryInfo

    // Shared individual message config.
    var labelTopConstraints = [NSLayoutConstraint]()
    [notificationsMessage, microphoneMessage, cameraMessage, photoLibraryMessage].forEach {
      labelTopConstraints.append($0.topAnchor.constraint(equalToSystemSpacingBelow: stepHeader.bottomAnchor, multiplier: 1))
    }
    NSLayoutConstraint.activate(labelTopConstraints)

    // Shared button config.
    [startButton, completeButton, continueButton].forEach {
      $0.contentEdgeInsets = UIEdgeInsets(top: 0,
                                          left: Metrics.buttonHeight/2.0,
                                          bottom: 0,
                                          right: Metrics.buttonHeight/2.0)
      wrappingView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.centerXAnchor.constraint(equalTo: wrappingView.centerXAnchor).isActive = true
      $0.heightAnchor.constraint(equalToConstant: Metrics.buttonHeight).isActive = true
      $0.widthAnchor.constraint(greaterThanOrEqualToConstant: Metrics.buttonWidth).isActive = true
      $0.setBackgroundImage(UIImage(named: "rounded_button_background"), for: .normal)
      $0.titleLabel?.font = ArduinoTypography.boldFont(forSize: 16)
      $0.setTitleColor(view.backgroundColor, for: .normal)
      $0.isHidden = true
    }

    // Start button.
    startButton.isHidden = false
    startButton.setTitle(String.permissionsGuideStartButtonTitle.uppercased(), for: .normal)
    let startButtonTopAnchor =
      startButton.topAnchor.constraint(equalTo: initialMessage.bottomAnchor,
                                       constant: Metrics.buttonSpacing)
    startButtonTopAnchor.priority = .defaultHigh
    startButtonTopAnchor.isActive = true
    logoImageView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: startButton.bottomAnchor,
                                              multiplier: 1.0).isActive = true
    startButton.addTarget(self, action: #selector(startGuideButtonPressed), for: .touchUpInside)

    // Complete button.
    completeButton.setTitle(String.permissionsGuideFinishButtonTitle.uppercased(), for: .normal)
    completeButton.topAnchor.constraint(equalTo: finalMessage.bottomAnchor,
                                        constant: Metrics.buttonSpacing).isActive = true
    completeButton.addTarget(self,
                             action: #selector(completeGuideButtonPressed),
                             for: .touchUpInside)

    // The continue button, to start each step's system prompt after a user has read the message.
    continueButton.setTitle(String.permissionsGuideContinueButtonTitle.uppercased(), for: .normal)
    continueButton.centerXAnchor.constraint(equalTo: wrappingView.centerXAnchor).isActive = true
    continueTopConstraint =
        continueButton.topAnchor.constraint(equalTo: notificationsMessage.bottomAnchor,
                                            constant: Metrics.buttonSpacing)
    continueTopConstraint?.priority = .defaultHigh-1
    continueTopConstraint?.isActive = true

    startButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: initialMessage.bottomAnchor,
                                     multiplier: 1).isActive = true

    // Step counter
    configureStepsImageView()
  }

  private func configureArduinoLogo() {
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.contentMode = .scaleAspectFit
    wrappingView.addSubview(logoImageView)
    logoImageView.centerXAnchor.constraint(equalTo: wrappingView.centerXAnchor).isActive = true
    logoImageView.bottomAnchor.constraint(equalTo: wrappingView.safeAreaLayoutGuide.bottomAnchor,
                                          constant: -Metrics.arduinoLogoBottomPadding).isActive = true
  }

  private func configureStepHeader() {
    stepIcon.setContentHuggingPriority(.required, for: .horizontal)

    stepTitle.font = ArduinoTypography.boldFont(forSize: 16)
    stepTitle.textColor = ArduinoColorPalette.grayPalette.tint600

    stepHeader.axis = .horizontal
    stepHeader.alignment = .center
    stepHeader.spacing = 10
    stepHeader.addArrangedSubview(stepIcon)
    stepHeader.addArrangedSubview(stepTitle)

    stepHeader.translatesAutoresizingMaskIntoConstraints = false
    wrappingView.addSubview(stepHeader)

    let leadingAnchor = stepHeader.leadingAnchor.constraint(equalTo: wrappingView.readableContentGuide.leadingAnchor)
    let trailingAnchor = stepHeader.trailingAnchor.constraint(equalTo: wrappingView.readableContentGuide.trailingAnchor)

    labelLeadingConstraints.append(leadingAnchor)
    labelTrailingConstraints.append(trailingAnchor)

    NSLayoutConstraint.activate([
      leadingAnchor,
      trailingAnchor,
      stepHeader.topAnchor.constraint(equalTo: headerImage.bottomAnchor,
                                      constant: Metrics.headerTopPaddingNarrow)
    ])
    stepHeader.isHidden = true
  }

  private func configureStepsImageView() {
    stepsImageView.isHidden = true
    stepsImageView.translatesAutoresizingMaskIntoConstraints = false
    stepsImageView.setContentCompressionResistancePriority(.required, for: .vertical)
    wrappingView.addSubview(stepsImageView)
    stepsImageView.centerXAnchor.constraint(equalTo: wrappingView.centerXAnchor).isActive = true
    stepsImageView.bottomAnchor.constraint(equalTo: wrappingView.safeAreaLayoutGuide.bottomAnchor,
                                           constant: -Metrics.arduinoLogoBottomPadding).isActive = true
    stepsImageView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: continueButton.bottomAnchor,
                                        multiplier: 1.0).isActive = true
  }

  // Updates constraints for labels. Used in rotation to ensure the best fit for various screen
  // sizes.
  private func updateConstraintsForSize(_ size: CGSize) {
    guard UIDevice.current.userInterfaceIdiom != .pad else { return }

    var headerTopPadding: CGFloat
    if size.isWiderThanTall {
      if size.width <= 568 {
        headerTopPadding = Metrics.headerTopPaddingWideSmallScreen
      } else {
        headerTopPadding = Metrics.headerTopPaddingWide
      }
    } else {
      if size.width <= 320 {
        headerTopPadding = Metrics.headerTopPaddingNarrowSmallScreen
      } else {
        headerTopPadding = Metrics.headerTopPaddingNarrow
      }
    }

    headerTopConstraint?.constant = headerTopPadding
    labelLeadingConstraints.forEach {
      $0.constant = size.isWiderThanTall ? Metrics.outerPaddingWide : Metrics.outerPaddingNarrow
    }
    labelTrailingConstraints.forEach {
      $0.constant = size.isWiderThanTall ? -Metrics.outerPaddingWide : -Metrics.outerPaddingNarrow
    }
  }

  // Animates to a step and fires a completion once done.
  private func animateToStep(animations: @escaping () -> Void,
                             completion: (() -> Void)? = nil) {
    animations()
    completion?()
  }

  // MARK: - Steps

  // Displays the done notice and then, after a delay, performs the next step.
  private func markStepDoneAndPerformNext() {
    performNextStep()
  }

  // Performs the next step in the guide or, if none are left, shows the conclusion.
  private func performNextStep() {
    guard steps.count > 0 else {
      stepsDone()
      return
    }

    let nextStep = steps.remove(at: 0)
    nextStep(self)()
  }

  // MARK: Welcome

  private func stepWelcome() {
    headerTitle.alpha = 1
    initialMessage.alpha = 1
  }

  // MARK: Push notifications

  // Ask for push notification permissions.
  private func stepNotifications() {
    updateContinueButtonConstraint(forLabel: notificationsMessage)
    continueButton.removeTarget(nil, action: nil, for: .allEvents)
    continueButton.addTarget(self,
                             action: #selector(checkForNotificationPermissions),
                             for: .touchUpInside)
    let showNotificationsState = {
      self.headerTitle.alpha = 0
      self.initialMessage.alpha = 0
      self.startButton.isHidden = true
      self.continueButton.isHidden = false
      self.continueButton.isEnabled = true
      self.notificationsMessage.alpha = 1
      self.logoImageView.isHidden = true
      self.stepsImageView.isHidden = false
      self.stepsImageView.image = UIImage(named: "permissions_step_1")
      self.stepHeader.isHidden = false
      self.stepIcon.image = UIImage(named: "permissions_step_notifications_icon")
      self.stepTitle.text = String.permissionsGuideNotificationsTitle.localizedUppercase
    }

    animateToStep(animations: showNotificationsState) {
      UIAccessibility.post(notification: .layoutChanged, argument: self.notificationsMessage)
    }
  }

  @objc private func checkForNotificationPermissions() {
    UIView.animate(withDuration: permissionCheckDuration, animations: {
      self.continueButton.isEnabled = false
    }) { (_) in
      LocalNotificationManager.shared.registerUserNotifications()
    }
  }

  // Listen for step 1 completion before moving to step 2.
  @objc private func notificationRegistrationComplete() {
    self.markStepDoneAndPerformNext()
  }

  // MARK: Microphone

  // Ask for microphone permissions.
  private func stepMicrophone() {
    updateContinueButtonConstraint(forLabel: microphoneMessage)
    continueButton.removeTarget(nil, action: nil, for: .allEvents)
    continueButton.addTarget(self,
                             action: #selector(checkForMicrophonePermissions),
                             for: .touchUpInside)
    let showNotificationsState = {
      self.continueButton.isEnabled = true
      self.notificationsMessage.alpha = 0
      self.microphoneMessage.alpha = 1
      self.stepsImageView.image = UIImage(named: "permissions_step_2")
      self.stepIcon.image = UIImage(named: "permissions_step_microphone_icon")
      self.stepTitle.text = String.permissionsGuideMicrophoneTitle.localizedUppercase
    }

    animateToStep(animations: showNotificationsState) {
      UIAccessibility.post(notification: .layoutChanged, argument: self.microphoneMessage)
    }
  }

  @objc private func checkForMicrophonePermissions() {
    UIView.animate(withDuration: permissionCheckDuration, animations: {
      self.continueButton.isEnabled = false
    }) { (_) in
      AVAudioSession.sharedInstance().requestRecordPermission { _ in
        DispatchQueue.main.async {
          self.markStepDoneAndPerformNext()
        }
      }
    }
  }

  // MARK: Camera

  // Ask for camera permissions.
  private func stepCamera() {
    updateContinueButtonConstraint(forLabel: cameraMessage)
    continueButton.removeTarget(nil, action: nil, for: .allEvents)
    continueButton.addTarget(self,
                             action: #selector(checkForCameraPermissions),
                             for: .touchUpInside)
    animateToStep(animations: {
      self.continueButton.isEnabled = true
      self.microphoneMessage.alpha = 0
      self.cameraMessage.alpha = 1
      self.stepsImageView.image = UIImage(named: "permissions_step_3")
      self.stepIcon.image = UIImage(named: "permissions_step_camera_icon")
      self.stepTitle.text = String.permissionsGuideCameraTitle.localizedUppercase
    }) {
      UIAccessibility.post(notification: .layoutChanged, argument: self.cameraMessage)
    }
  }

  @objc private func checkForCameraPermissions() {
    UIView.animate(withDuration: permissionCheckDuration, animations: {
      self.continueButton.isEnabled = false
    }) { (_) in
      let cameraAuthorizationStatus =
          AVCaptureDevice.authorizationStatus(for: .video)
      switch cameraAuthorizationStatus {
      case .authorized, .denied, .restricted:
        self.markStepDoneAndPerformNext()
      case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { _ in
          DispatchQueue.main.sync {
            self.markStepDoneAndPerformNext()
          }
        }
      @unknown default:
        break
      }
    }
  }

  // MARK: Photo library

  // Ask for photo library permissions.
  private func stepPhotoLibrary() {
    updateContinueButtonConstraint(forLabel: photoLibraryMessage)
    continueButton.removeTarget(nil, action: nil, for: .allEvents)
    continueButton.addTarget(self,
                             action: #selector(checkForPhotoLibraryPermissions),
                             for: .touchUpInside)
    animateToStep(animations: {
      self.continueButton.isEnabled = true
      self.cameraMessage.alpha = 0
      self.photoLibraryMessage.alpha = 1
      self.stepsImageView.image = UIImage(named: "permissions_step_4")
      self.stepIcon.image = UIImage(named: "permissions_step_photos_icon")
      self.stepTitle.text = String.permissionsGuidePhotosTitle.localizedUppercase
    }) {
      UIAccessibility.post(notification: .layoutChanged, argument: self.photoLibraryMessage)
    }
  }

  @objc private func checkForPhotoLibraryPermissions() {
    UIView.animate(withDuration: permissionCheckDuration, animations: {
      self.continueButton.isEnabled = false
    }) { (_) in
      PHPhotoLibrary.requestAuthorization { _ in
        DispatchQueue.main.sync {
          self.markStepDoneAndPerformNext()
        }
      }
    }
  }

  // MARK: All steps complete

  // Thank the user and add a completion button which dismisses the guide.
  private func stepsDone() {
    animateToStep(animations: {
      self.stepHeader.isHidden = true
      self.continueButton.isHidden = true
      self.photoLibraryMessage.alpha = 0
      self.finalMessage.alpha = 1
      self.completeButton.isHidden = false
      self.stepsImageView.isHidden = true
    }) {
      UIAccessibility.post(notification: .layoutChanged, argument: self.finalMessage)
    }
  }

  // MARK: - Helpers

  private func updateContinueButtonConstraint(forLabel label: UILabel) {
    continueTopConstraint?.isActive = false
    continueTopConstraint = continueButton.topAnchor.constraint(equalTo: label.bottomAnchor,
                                                                constant: Metrics.buttonSpacing)
    continueTopConstraint?.priority = .defaultHigh-1
    continueTopConstraint?.isActive = true
    continueButton.layoutIfNeeded()
  }

  // MARK: - User actions

  @objc private func startGuideButtonPressed() {
    performNextStep()
  }

  @objc private func completeGuideButtonPressed() {
    delegate?.permissionsGuideDidComplete(self)
  }

}

// swiftlint:enable type_body_length
