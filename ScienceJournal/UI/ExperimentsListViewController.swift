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
import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialFeatureHighlight
import MaterialComponents.MaterialPalettes
import MaterialComponents.MaterialSnackbar

protocol ExperimentsListViewControllerDelegate: class {
  /// Informs the delegate the sidebar should be shown.
  func experimentsListShowSidebar()

  /// Informs the delegate that Drive sync status should be refreshed.
  func experimentsListManualSync()

  /// Informs the delegate the experiment with the given ID should be shown.
  ///
  /// - Parameter experimentID: An experiment ID.
  func experimentsListShowExperiment(withID experimentID: String)

  /// Informs the delegate a new experiment should be created and shown.
  func experimentsListShowNewExperiment()

  /// Informs the delegate the archive state for an experiment should be toggled.
  ///
  /// - Parameter experimentID: An experiment ID.
  func experimentsListToggleArchiveStateForExperiment(withID experimentID: String)

  /// Informs the delegate the user has deleted the experiment.
  ///
  /// - Parameter experimentID: An experiment ID.
  func experimentsListDeleteExperiment(withID experimentID: String)

  /// Informs the delegate the deletion was completed and not undone.
  ///
  /// - Parameter deletedExperiment: A deleted experiment.
  func experimentsListDeleteExperimentCompleted(_ deletedExperiment: DeletedExperiment)

  /// Informs the delegate the claim experiments view controller should be shown.
  func experimentsListShowClaimExperiments()

  /// Informs the delegate the experiments list appeared.
  func experimentsListDidAppear()

  /// Informs the delegate the experiment title changed.
  ///
  /// - Parameters:
  ///   - title: The experiment title.
  ///   - experimentID: The ID of the experiment that changed.
  func experimentsListDidSetTitle(_ title: String?, forExperimentID experimentID: String)

  /// Informs the delegate the experiment cover image changed.
  ///
  /// - Parameters:
  ///   - imageData: The cover image data.
  ///   - metadata: The metadata associated with the image.
  ///   - experiment: The ID of the experiment whose cover image was set.
  func experimentsListDidSetCoverImageData(_ imageData: Data?,
                                           metadata: NSDictionary?,
                                           forExperimentID experimentID: String)

  /// Informs the delegate the experiment should be exported as a PDF.
  ///
  /// - Parameters:
  ///   - experiment: The experiment to export.
  ///   - completionHandler: The completion handler to call when export is complete.
  func experimentsListExportExperimentPDF(
    _ experiment: Experiment,
    completionHandler: @escaping PDFExportController.CompletionHandler)

  /// Asks the delegate for a pop up menu action to initiate export flow.
  ///
  /// - Parameters:
  ///   - experiment: The experiment to be exported.
  ///   - presentingViewController: The presenting view controller.
  ///   - sourceView: View to anchor a popover to display.
  func experimentsListExportFlowAction(for experiment: Experiment,
                                       from presentingViewController: UIViewController,
                                       sourceView: UIView) -> PopUpMenuAction
}

// swiftlint:disable type_body_length
/// A list of the user's experiments. This is the view the user sees on launch.
class ExperimentsListViewController: MaterialHeaderViewController, ExperimentStateListener,
    ExperimentsListItemsDelegate, ExperimentsListCellDelegate {

  // MARK: - Constants

  private let createExperimentHighlightTimeInterval: TimeInterval = 10
  private let fabPadding: CGFloat = 16.0

  // MARK: - Properties

  weak var delegate: ExperimentsListViewControllerDelegate?

  /// The menu bar button. Exposed for testing.
  let menuBarButton = MaterialMenuBarButtonItem()

  /// The no connection bar button. Exposed for testing.
  let noConnectionBarButton = MaterialBarButtonItem()
  
  var shouldAllowManualSync: Bool {
    didSet {
      guard shouldAllowManualSync != oldValue else { return }
      guard isViewLoaded else { return }
      configurePullToRefresh()
    }
  }

  private let accountsManager: AccountsManager
  private let commonUIComponents: CommonUIComponents
  private let createExperimentFAB = MDCFloatingButton()
  private var createExperimentHighlightTimer: Timer?
  private let documentManager: DocumentManager
  private let emptyView = EmptyView(title: String.emptyProject, imageName: "empty_experiment_list")
  private var highlightController: MDCFeatureHighlightViewController?
  private let metadataManager: MetadataManager
  private let networkAvailability: NetworkAvailability
  private var pullToRefreshController: PullToRefreshController?
  private var pullToRefreshControllerForEmptyView: PullToRefreshController?
  private let sensorDataManager: SensorDataManager
  private let exportType: UserExportType
  private let snackbarCategoryArchivedExperiment = "snackbarCategoryArchivedExperiment"
  private let snackbarCategoryDeletedExperiment = "snackbarCategoryDeletedExperiment"
  private let preferenceManager: PreferenceManager
  private let experimentsListItemsViewController: ExperimentsListItemsViewController
  private let existingDataMigrationManager: ExistingDataMigrationManager?
  private let saveToFilesHandler = SaveToFilesHandler()

  override var trackedScrollView: UIScrollView? {
    return experimentsListItemsViewController.collectionView
  }

  /// Sets the number of unclaimed experiments that exist. When the count is greater than one, the
  /// claim experiments view will be shown as a collection view header and in the empty view.
  private var numberOfUnclaimedExperiments: Int = 0 {
    didSet {
      guard numberOfUnclaimedExperiments != oldValue else { return }

      let shouldShowClaimExperimentsView = numberOfUnclaimedExperiments > 0

      // Empty view
      emptyView.emptyViewDelegate = self
      emptyView.isClaimExperimentsViewHidden = !shouldShowClaimExperimentsView
      if shouldShowClaimExperimentsView {
        emptyView.claimExperimentsView.setNumberOfUnclaimedExperiments(numberOfUnclaimedExperiments)
      }

      if shouldShowClaimExperimentsView {
        // Collection view header.
        let headerConfigurationBlock: ExperimentsListHeaderConfigurationBlock = { [weak self] in
          if let strongSelf = self, let header = $0 as? ClaimExperimentsHeaderView {
            header.claimExperimentsView.delegate = strongSelf
            header.claimExperimentsView.setNumberOfUnclaimedExperiments(
                strongSelf.numberOfUnclaimedExperiments)
          }
        }
        let headerSizeBlock: ExperimentsListHeaderSizeBlock = { [weak self] (width) in
          let claimExperimentsView = ClaimExperimentsView()
          claimExperimentsView.setNumberOfUnclaimedExperiments(self?.numberOfUnclaimedExperiments ?? 0)
          let targetSize = CGSize(width: width,
                                  height: UIView.layoutFittingCompressedSize.height)
          let size = claimExperimentsView.systemLayoutSizeFitting(targetSize,
                                                                  withHorizontalFittingPriority: .required,
                                                                  verticalFittingPriority: .defaultLow)
          return size
        }
        experimentsListItemsViewController.setCollectionViewHeader(
            configurationBlock: headerConfigurationBlock,
            headerSizeBlock: headerSizeBlock,
            class: ClaimExperimentsHeaderView.self)
      } else {
        experimentsListItemsViewController.removeCollectionViewHeader()
      }
    }
  }

  // MARK: - Public

  /// Designated initializer.
  ///
  /// - Parameters:
  ///   - accountsManager: The accounts manager.
  ///   - analyticsReporter: The analytics reporter.
  ///   - commonUIComponents: Common UI components.
  ///   - existingDataMigrationManager: The existing data migration manager.
  ///   - metadataManager: The metadata manager.
  ///   - networkAvailability: Network availability.
  ///   - preferenceManager: The preference manager.
  ///   - sensorDataManager: The sensor data manager.
  ///   - documentManager: The document manager.
  ///   - exportType: The export option type to show.
  ///   - shouldAllowManualSync: Whether to allow manual syncing.
  init(accountsManager: AccountsManager,
       analyticsReporter: AnalyticsReporter,
       commonUIComponents: CommonUIComponents,
       existingDataMigrationManager: ExistingDataMigrationManager?,
       metadataManager: MetadataManager,
       networkAvailability: NetworkAvailability,
       preferenceManager: PreferenceManager,
       sensorDataManager: SensorDataManager,
       documentManager: DocumentManager,
       exportType: UserExportType,
       shouldAllowManualSync: Bool) {
    self.accountsManager = accountsManager
    self.commonUIComponents = commonUIComponents
    self.existingDataMigrationManager = existingDataMigrationManager
    self.metadataManager = metadataManager
    self.networkAvailability = networkAvailability
    self.preferenceManager = preferenceManager
    self.sensorDataManager = sensorDataManager
    self.documentManager = documentManager
    self.exportType = exportType
    self.shouldAllowManualSync = shouldAllowManualSync

    experimentsListItemsViewController =
        ExperimentsListItemsViewController(cellClass: ExperimentsListCell.self,
                                           metadataManager: metadataManager,
                                           preferenceManager: preferenceManager)

    super.init(analyticsReporter: analyticsReporter)

    experimentsListItemsViewController.delegate = self
    experimentsListItemsViewController.cellConfigurationBlock = {
        [weak self] (cell, overview, image) in
      if let strongSelf = self, let cell = cell as? ExperimentsListCell, let overview = overview {
        cell.configureForExperimentOverview(overview, delegate: strongSelf, image: image)
      }
    }
    experimentsListItemsViewController.cellSizeBlock = { (width) in
      return ExperimentsListCell.itemSize(inWidth: width)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = String.appName

    // Experiments list items view controller.
    experimentsListItemsViewController.scrollDelegate = self
    experimentsListItemsViewController.view.translatesAutoresizingMaskIntoConstraints = false
    addChild(experimentsListItemsViewController)
    view.addSubview(experimentsListItemsViewController.view)
    experimentsListItemsViewController.view.pinToEdgesOfView(view)

    let sidebarMenuButton = UIBarButtonItem(image: UIImage(named: "ic_menu"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(sidebarMenuButtonPressed))
    sidebarMenuButton.tintColor = .white
    sidebarMenuButton.accessibilityLabel = String.sidebarMenuContentDescription
    sidebarMenuButton.accessibilityHint = String.sidebarMenuContentDetails
    navigationItem.leftBarButtonItem = sidebarMenuButton

    menuBarButton.button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
    menuBarButton.button.setImage(UIImage(named: "ic_more_horiz"), for: .normal)

    noConnectionBarButton.button.addTarget(self,
                                           action: #selector(noConnectionButtonPressed),
                                           for: .touchUpInside)
    let noConnectionImage = UIImage(named: "ic_signal_wifi_statusbar_connected_no_internet")
    noConnectionBarButton.button.setImage(noConnectionImage, for: .normal)
    noConnectionBarButton.button.accessibilityHint = String.driveErrorNoConnection
    noConnectionBarButton.button.accessibilityLabel =
        String.driveErrorNoConnectionContentDescription
    noConnectionBarButton.button.accessibilityTraits = .staticText
    noConnectionBarButton.button.tintColor = .white

    updateRightBarButtonItems()

    // Configure the empty view.
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(emptyView)
    emptyView.topAnchor.constraint(equalTo: appBar.navigationBar.bottomAnchor).isActive = true
    emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    // Add the FAB.
    view.addSubview(createExperimentFAB)
    createExperimentFAB.accessibilityLabel = String.btnNewExperimentContentDescription
    createExperimentFAB.setImage(UIImage(named: "ic_add"), for: .normal)
    createExperimentFAB.tintColor = .white
    createExperimentFAB.setBackgroundColor(ArduinoColorPalette.grayPalette.tint500!,
                                           for: .normal)
    createExperimentFAB.addTarget(self,
                                  action: #selector(addExperimentButtonPressed),
                                  for: .touchUpInside)
    createExperimentFAB.translatesAutoresizingMaskIntoConstraints = false
    createExperimentFAB.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -fabPadding).isActive = true
    createExperimentFAB.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -fabPadding).isActive = true
    
    // Configure the pull to refresh gesture
    configurePullToRefresh()

    experimentsListItemsViewController.collectionView.contentInset =
        UIEdgeInsets(top: experimentsListItemsViewController.collectionView.contentInset.top,
                     left: 0,
                     bottom: MDCFloatingButton.defaultDimension(),
                     right: 0)

    // Listen to notifications of newly imported experiments.
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(experimentImported),
                                           name: .documentManagerDidImportExperiment,
                                           object: nil)

    // Listen to notifications of newly downloaded assets.
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(downloadedImages),
                                           name: .driveSyncManagerDownloadedImages,
                                           object: nil)

    // Listen to notifications of network availability changing.
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(networkAvailabilityChanged),
                                           name: .NetworkAvailabilityChanged,
                                           object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // Invalidate the feature highlight timer on viewDidAppear to prevent an older timer from
    // firing before creating a new timer.
    createExperimentHighlightTimer?.invalidate()
    createExperimentHighlightTimer = nil

    // After some time, if user has no experiments and hasn't been shown the feature highlight
    // before, give them a nudge if necessary.
    if !preferenceManager.hasUserSeenExperimentHighlight {
      createExperimentHighlightTimer =
          Timer.scheduledTimer(timeInterval: createExperimentHighlightTimeInterval,
                               target: self,
                               selector: #selector(highlightCreateActionIfNeeded),
                               userInfo: nil,
                               repeats: false)
      RunLoop.main.add(createExperimentHighlightTimer!, forMode: .common)
    }

    delegate?.experimentsListDidAppear()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Unoding an archive or delete is unstable when this view is off screen so dismiss snackbars.
    [snackbarCategoryArchivedExperiment, snackbarCategoryDeletedExperiment].forEach {
      MDCSnackbarManager.default.dismissAndCallCompletionBlocks(withCategory: $0)
    }

    // Make sure the highlight doesn't appear when off screen.
    createExperimentHighlightTimer?.invalidate()
    createExperimentHighlightTimer = nil
    dismissFeatureHighlightIfNecessary()
    highlightController = nil
  }

  func refresh() {
    // Recreate sections in case experiments were created or modified while view was off screen.
    experimentsListItemsViewController.updateExperiments()
    updateEmptyView(animated: false)
    
    refreshUnclaimedExperiments()
  }
  
  /// Handles the event that an experiment fails to load.
  func handleExperimentLoadingFailure() {
    experimentsListItemsViewController.handleExperimentLoadingFailure()
  }

  /// Inserts an experiment overview.
  ///
  /// - Parameters:
  ///   - overview: An experiment overview.
  ///   - atBeginning: Whether to insert the overview at the beginning.
  func insertOverview(_ overview: ExperimentOverview, atBeginning: Bool = false) {
    experimentsListItemsViewController.insertOverview(overview, atBeginning: atBeginning)
  }

  /// Refreshes the number of unclaimed experiments shown in the header.
  func refreshUnclaimedExperiments() {
    if let existingDataMigrationManager = existingDataMigrationManager {
      numberOfUnclaimedExperiments = existingDataMigrationManager.numberOfExistingExperiments
    }
  }

  /// Reloads the experiments and refreshes the view.
  func reloadExperiments() {
    // If view isn't visible it will automatically be reloaded when the view appears.
    if isViewVisible {
      experimentsListItemsViewController.updateExperiments()
      updateEmptyView(animated: false)
    }
  }

  /// Updates the nav item's right bar button items. Exposed for testing.
  func updateRightBarButtonItems() {
    var rightBarButtonItems: [UIBarButtonItem] = [menuBarButton]
    if accountsManager.supportsAccounts && networkAvailability.isAvailable == false {
      rightBarButtonItems.append(noConnectionBarButton)
    }
    navigationItem.rightBarButtonItems = rightBarButtonItems
  }

  /// Starts the pull to refresh animation.
  func startPullToRefreshAnimation() {
    pullToRefreshController?.startRefreshing()
    pullToRefreshControllerForEmptyView?.startRefreshing()
  }

  /// Ends the pull to refresh animation.
  func endPullToRefreshAnimation() {
    pullToRefreshController?.endRefreshing()
    pullToRefreshControllerForEmptyView?.endRefreshing()
  }

  // MARK: - Private

  // Feature highlight that nudges the user to create an experiment if they have one or fewer
  // experiments.
  @objc private func highlightCreateActionIfNeeded() {
    guard !preferenceManager.hasUserSeenExperimentHighlight else { return }
    guard metadataManager.experimentOverviews.count <= 1 else {
      preferenceManager.hasUserSeenExperimentHighlight = true
      return
    }

    // Set up a fake button to display a highlighted state and have a nice shadow.
    let fakeFAB = MDCFloatingButton()
    fakeFAB.accessibilityLabel = String.btnNewExperimentContentDescription
    fakeFAB.setImage(UIImage(named: "ic_add"), for: .normal)
    fakeFAB.tintColor = .white
    fakeFAB.setBackgroundColor(ArduinoColorPalette.grayPalette.tint500!, for: .normal)
    fakeFAB.sizeToFit()

    // Show the highlight.
    let highlight = MDCFeatureHighlightViewController(highlightedView: createExperimentFAB,
                                                      andShow: fakeFAB) { (accepted) in
      if accepted { self.addExperimentButtonPressed() }
    }

    fakeFAB.addTarget(highlight,
                      action: #selector(highlight.acceptFeature),
                      for: .touchUpInside)
    highlight.titleText = String.experimentsTutorialTitle
    highlight.bodyText = String.experimentsTutorialMessage
    highlight.outerHighlightColor = ArduinoColorPalette.defaultPalette.tint700
    highlight.titleFont = ArduinoTypography.boldFont(forSize: ArduinoTypography.FontSize.Medium.rawValue)
    highlight.titleColor = ArduinoColorPalette.defaultPalette.accent700
    highlight.bodyFont = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.Small.rawValue)
    highlight.bodyColor = ArduinoColorPalette.defaultPalette.accent700
    present(highlight, animated: true)
    highlightController = highlight

    preferenceManager.hasUserSeenExperimentHighlight = true
  }

  /// Dismisses the feature highlight if it's on screen, without animation.
  func dismissFeatureHighlightIfNecessary() {
    highlightController?.dismiss(animated: false)
  }

  private func updateEmptyView(animated: Bool) {
    UIView.animate(withDuration: animated ? 0.5 : 0) {
      self.emptyView.alpha = self.experimentsListItemsViewController.isEmpty ? 1 : 0
    }
  }

  private func configurePullToRefresh() {
    if shouldAllowManualSync {
      pullToRefreshController = commonUIComponents.pullToRefreshController(
        forScrollView: experimentsListItemsViewController.collectionView, shouldShowLabel: true) { [weak self] in
        self?.performPullToRefresh()
      }
      if pullToRefreshController != nil {
        // Pull to refresh is not visible when allowing the header to expand past its max height.
        appBar.headerViewController.headerView.canOverExtend = false
        // Collection view needs to bounce vertical for pull to refresh.
        experimentsListItemsViewController.collectionView.alwaysBounceVertical = true
      }
      pullToRefreshControllerForEmptyView =
          commonUIComponents.pullToRefreshController(forScrollView: emptyView, shouldShowLabel: true) { [weak self] in
        self?.performPullToRefresh()
      }
      if pullToRefreshControllerForEmptyView != nil {
        // Empty view needs to bounce vertical for pull to refresh.
        emptyView.alwaysBounceVertical = true
      }
    } else {
      pullToRefreshController = nil
      pullToRefreshControllerForEmptyView = nil
      appBar.headerViewController.headerView.canOverExtend = true
    }
  }
  
  private func performPullToRefresh() {
    delegate?.experimentsListManualSync()
    analyticsReporter.track(.syncManualRefresh)
  }

  // MARK: - Accessibility

  override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
    let isEmptyViewShowing = emptyView.alpha == 1
    guard let pullToRefreshController = isEmptyViewShowing ?
        pullToRefreshControllerForEmptyView : pullToRefreshController,
        direction == .up else {
      return super.accessibilityScroll(direction)
    }

    let scrollView =
        isEmptyViewShowing ? emptyView : experimentsListItemsViewController.collectionView
    let shouldPullToRefresh = scrollView.contentOffset.y <= -scrollView.contentInset.top

    guard shouldPullToRefresh else {
      return super.accessibilityScroll(direction)
    }

    UIAccessibility.post(notification: .announcement,
                         argument: String.pullToRefreshContentDescription)
    pullToRefreshController.startRefreshing()
    performPullToRefresh()
    return true
  }

  // MARK: - User Actions

  @objc private func sidebarMenuButtonPressed() {
    delegate?.experimentsListShowSidebar()
  }

  @objc private func menuButtonPressed() {
    let currentlyShowingArchived = preferenceManager.shouldShowArchivedExperiments
    let icon =
        UIImage(named: currentlyShowingArchived ? "ic_check_box" : "ic_check_box_outline_blank")
    let popUpMenu = PopUpMenuViewController()
    popUpMenu.addAction(PopUpMenuAction(title: String.actionIncludeArchivedExperiments,
                                        icon: icon) { _ -> Void in
      self.preferenceManager.shouldShowArchivedExperiments = !currentlyShowingArchived
      self.experimentsListItemsViewController.shouldIncludeArchivedExperiments =
          !currentlyShowingArchived
      self.updateEmptyView(animated: true)
    })
    popUpMenu.present(from: self, position: .sourceView(menuBarButton.button))
  }

  @objc private func addExperimentButtonPressed() {
    // User is taking the featured action, so ensure that they never see the feature highlight.
    preferenceManager.hasUserSeenExperimentHighlight = true
    delegate?.experimentsListShowNewExperiment()
  }

  @objc private func noConnectionButtonPressed() {
    showSnackbar(withMessage: String.driveErrorNoConnection)
  }

  // MARK: - Notifications

  @objc private func experimentImported() {
    guard Thread.isMainThread else {
      DispatchQueue.main.async {
        self.experimentImported()
      }
      return
    }

    // Update the overviews.
    reloadExperiments()
  }

  @objc private func downloadedImages(notification: Notification) {
    guard Thread.isMainThread else {
      DispatchQueue.main.async {
        self.downloadedImages(notification: notification)
      }
      return
    }

    guard isViewVisible,
        let imagePaths = notification.userInfo?[DriveSyncUserInfoConstants.downloadedImagePathsKey]
            as? [String] else {
      return
    }

    experimentsListItemsViewController.reloadCells(forDownloadedImagePaths: imagePaths)
  }

  @objc private func networkAvailabilityChanged() {
    updateRightBarButtonItems()
  }

  // MARK: - ExperimentStateListener

  func experimentStateArchiveStateChanged(forExperiment experiment: Experiment,
                                          overview: ExperimentOverview,
                                          undoBlock: @escaping () -> Void) {
    let didCollectionViewChange = experimentsListItemsViewController.experimentArchivedStateChanged(
        forExperimentOverview: overview, updateCollectionView: isViewVisible)

    // Only show the snackbar and update the empty view if the view is visible.
    guard isViewVisible else {
      return
    }

    if didCollectionViewChange {
      updateEmptyView(animated: true)
    }

    if overview.isArchived {
      // Only show the snack bar if the experiment is now archived.
      showUndoSnackbar(withMessage: String.archivedExperimentMessage,
                       category: snackbarCategoryArchivedExperiment,
                       undoBlock: undoBlock)
    } else {
      // If the user is unarchiving, hide any archived state undo snackbars.
      MDCSnackbarManager.default.dismissAndCallCompletionBlocks(
          withCategory: snackbarCategoryArchivedExperiment)
    }
  }

  func experimentStateDeleted(_ deletedExperiment: DeletedExperiment, undoBlock: (() -> Void)?) {
    let didCollectionViewChange = experimentsListItemsViewController.experimentWasRemoved(
        withID: deletedExperiment.experimentID,
        updateCollectionView: isViewVisible)

    // Only update the empty view if the view is visible.
    if isViewVisible && didCollectionViewChange {
      updateEmptyView(animated: true)
    }

    // Not all delete actions can be undone.
    guard let undoBlock = undoBlock else {
      delegate?.experimentsListDeleteExperimentCompleted(deletedExperiment)
      return
    }

    var didUndo = false
    showUndoSnackbar(withMessage: String.deletedExperimentMessage,
                     category: snackbarCategoryDeletedExperiment,
                     undoBlock: {
                      didUndo = true
                      undoBlock()
    }) { (_) in
      if !didUndo {
        self.delegate?.experimentsListDeleteExperimentCompleted(deletedExperiment)
      }
    }
  }

  func experimentStateRestored(_ experiment: Experiment, overview: ExperimentOverview) {
    let didCollectionViewChange = experimentsListItemsViewController.experimentWasRestored(
        forExperimentOverview: overview, updateCollectionView: isViewVisible)

    if didCollectionViewChange {
      updateEmptyView(animated: true)
    }
  }

  // MARK: - ExperimentsListItemsDelegate

  func experimentsListItemsViewControllerDidSelectExperiment(withID experimentID: String) {
    delegate?.experimentsListShowExperiment(withID: experimentID)
  }

  // MARK: - ExperimentsListCellDelegate

  func menuButtonPressedForCell(_ cell: ExperimentsListCell, attachmentButton: UIButton) {
    guard let overview = experimentsListItemsViewController.overview(forCell: cell) else { return }
    let archiveTitle = overview.isArchived ? String.actionUnarchive : String.actionArchive
    let archiveIcon = overview.isArchived ? UIImage(named: "ic_unarchive") : UIImage(named: "ic_archive")
    let archiveAccessibilityLabel = overview.isArchived ?
        String.actionUnarchiveExperimentContentDescription :
        String.actionArchiveExperimentContentDescription

    let popUpMenu = PopUpMenuViewController()

    // Edit.
    popUpMenu.addAction(PopUpMenuAction(title: String.actionEdit,
                                        icon: UIImage(named: "ic_edit")) { _ -> Void in
      guard let experiment = self.metadataManager.experiment(withID: overview.experimentID) else {
        return
      }
      let editExperimentVC = EditExperimentViewController(experiment: experiment,
                                                          analyticsReporter: self.analyticsReporter,
                                                          metadataManager: self.metadataManager)
      editExperimentVC.delegate = self
      self.present(editExperimentVC, animated: true)
    })

    // Archive.
    popUpMenu.addAction(PopUpMenuAction(
        title: archiveTitle,
        icon: archiveIcon,
        accessibilityLabel: archiveAccessibilityLabel) { _ -> Void in
      self.delegate?.experimentsListToggleArchiveStateForExperiment(withID: overview.experimentID)
    })

    // Export
    if !RecordingState.isRecording,
        let experiment = metadataManager.experiment(withID: overview.experimentID),
        !experiment.isEmpty {
      if let action = delegate?.experimentsListExportFlowAction(for: experiment,
                                                                from: self,
                                                                sourceView: attachmentButton) {
        popUpMenu.addAction(action)
      }
    }

    // Delete.
    popUpMenu.addAction(PopUpMenuAction(
        title: String.actionDelete,
        icon: UIImage(named: "ic_delete"),
        accessibilityLabel: String.actionDeleteExperimentContentDescription) { _ -> Void in
      // Prompt the user to confirm deletion.
      let alertController = MDCAlertController(title: String.deleteExperimentDialogTitle,
                                               message: String.deleteExperimentDialogMessage)
      let cancelAction = MDCAlertAction(title: String.btnDeleteObjectCancel)
      let deleteAction = MDCAlertAction(title: String.btnDeleteObjectConfirm) { _ in
        // Delete the experiment and update the collection view.
        self.delegate?.experimentsListDeleteExperiment(withID: overview.experimentID)
      }
      alertController.addAction(cancelAction)
      alertController.addAction(deleteAction)
      alertController.accessibilityViewIsModal = true
      if let cancelButton = alertController.button(for: cancelAction),
         let okButton = alertController.button(for: deleteAction) {
        alertController.styleAlertCancel(button: cancelButton)
        alertController.styleAlertOk(button: okButton)
      }
      self.present(alertController, animated: true)
    })

    popUpMenu.present(from: self, position: .sourceView(attachmentButton))
  }

  // MARK: - UIGestureRecognizerDelegate

  override func interactivePopGestureShouldBegin() -> Bool {
    // The MaterialHeaderCollectionViewController overrides interactive pop gestures and defaults
    // to allowing the gesture, but ExperimentsListViewController is the root view for the nav
    // stack and allowing it to attempt to pop back breaks the nav controller. Instead, disable this
    // behavior in this VC.
    return false
  }

}
// swiftlint:enable type_body_length

// MARK: - EditExperimentViewControllerDelegate

extension ExperimentsListViewController: EditExperimentViewControllerDelegate {

  func editExperimentViewControllerDidSetTitle(_ title: String?,
                                               forExperimentID experimentID: String) {
    delegate?.experimentsListDidSetTitle(title, forExperimentID: experimentID)
    experimentsListItemsViewController.collectionView.reloadData()
  }

  func editExperimentViewControllerDidSetCoverImageData(_ imageData: Data?,
                                                        metadata: NSDictionary?,
                                                        forExperimentID experimentID: String) {
    delegate?.experimentsListDidSetCoverImageData(imageData, metadata: metadata,
                                                  forExperimentID: experimentID)
    experimentsListItemsViewController.collectionView.reloadData()
  }

}

// MARK: - ClaimExperimentsViewDelegate

extension ExperimentsListViewController: ClaimExperimentsViewDelegate {

  func claimExperimentsViewDidPressClaimExperiments() {
    delegate?.experimentsListShowClaimExperiments()
  }

}

// MARK: - EmptyViewDelegate

extension ExperimentsListViewController: EmptyViewDelegate {

  func emptyViewDidPressClaimExperiments() {
    delegate?.experimentsListShowClaimExperiments()
  }

}
