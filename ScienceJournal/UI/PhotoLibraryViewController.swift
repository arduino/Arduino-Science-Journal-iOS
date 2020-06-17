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

import Photos
import UIKit

import third_party_objective_c_material_components_ios_components_Buttons_Buttons

/// Subclass of the photo library view controller for analytics purposes and uses a check mark
/// action bar button instead of a send icon.
open class StandalonePhotoLibraryViewController: PhotoLibraryViewController {

  public init(analyticsReporter: AnalyticsReporter) {
    super.init(actionBarButtonType: .check,
               selectionMode: .single,
               analyticsReporter: analyticsReporter)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

}

// swiftlint:disable type_body_length

/// View controller for selecting photos from the library.
open class PhotoLibraryViewController: ScienceJournalViewController, UICollectionViewDataSource,
                                       UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
                                       PhotoLibraryDataSourceDelegate, DrawerItemViewController,
                                       DrawerPositionListener, PhotoLibraryCellDelegate {

  enum Metrics {
    static let sendFABPadding: CGFloat = 32.0
    static let sendFABDisabledAlpha: CGFloat = 0.6
    static let sendFABImage = UIImage(named: "ic_send")?.imageFlippedForRightToLeftLayoutDirection()
    static let sendFABContentInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
  }

  /// Determines whether a user can select a single or multiple images.
  public enum SelectionMode {
    case single
    case multiple
  }

  /// Represents an image that a user has selected.
  /// It allows comparison via the `asset` property.
  private struct SelectedImage {
    let asset: PHAsset
    let image: UIImage
    let metadata: NSDictionary?
  }

  // MARK: - Properties

  /// The photo library data source.
  let photoLibraryDataSource = PhotoLibraryDataSource()

  /// The selection delegate.
  weak var delegate: ImageSelectorDelegate?

  private var collectionView: UICollectionView

  // The disabled view when permission is not granted.
  private let disabledView = DisabledInputView()

  /// The photo library cell's reuse identifier.
  static let reuseIdentifier = "PhotoLibraryCell"

  /// The photo library cell inter-item spacing.
  static let interitemSpacing: CGFloat = 1

  /// The photo library item size.
  var itemSize: CGSize {
    let totalWidth = collectionView.bounds.size.width - view.safeAreaInsetsOrZero.left -
        view.safeAreaInsetsOrZero.right
    let approximateWidth: CGFloat = 90
    let numberOfItemsInWidth = floor(totalWidth / approximateWidth)
    let dimension = (totalWidth - PhotoLibraryViewController.interitemSpacing *
        (numberOfItemsInWidth - 1)) / numberOfItemsInWidth
    return CGSize(width: dimension, height: dimension)
  }

  private let actionBar: ActionBar
  private let actionBarWrapper = UIView()
  private var actionBarWrapperHeightConstraint: NSLayoutConstraint?
  private var drawerPanner: DrawerPanner?
  private let selectionMode: SelectionMode

  /// Button for action area design
  private let sendFAB = MDCFloatingButton()

  /// The currently selected images.
  /// When `selectionMode` is `.single`, only one image can be selected at a time.
  private var selectedImages: [SelectedImage] = [] {
    didSet {
      actionBar.button.isEnabled = !selectedImages.isEmpty
      sendFAB.isEnabled = !selectedImages.isEmpty
    }
  }

  // MARK: - Public

  /// Designated initializer.
  ///
  /// - Parameters:
  ///   - actionBarButtonType: The button type for the action bar. Default is a send button.
  ///   - analyticsReporter: An AnalyticsReporter.
  public init(actionBarButtonType: ActionBar.ButtonType = .send,
              selectionMode: SelectionMode,
              analyticsReporter: AnalyticsReporter) {
    // TODO: Confirm layout is correct in landscape.
    let collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.minimumLineSpacing = 1
    collectionViewLayout.minimumInteritemSpacing = PhotoLibraryViewController.interitemSpacing
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.isAccessibilityElement = false
    collectionView.shouldGroupAccessibilityChildren = true

    actionBar = ActionBar(buttonType: actionBarButtonType)

    self.selectionMode = selectionMode

    super.init(analyticsReporter: analyticsReporter)
    photoLibraryDataSource.delegate = self

    NotificationCenter.default.addObserver(
        self,
        selector: #selector(accessibilityVoiceOverStatusChanged),
        name: UIAccessibility.voiceOverStatusDidChangeNotification,
        object: nil)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    updateTitle()

    // Collection view.
    // Always register collection view cells early to avoid a reload occurring first.
    collectionView.register(PhotoLibraryCell.self,
                            forCellWithReuseIdentifier: PhotoLibraryViewController.reuseIdentifier)
    view.addSubview(collectionView)
    collectionView.alwaysBounceVertical = true
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .white
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.pinToEdgesOfView(view)
    collectionView.panGestureRecognizer.addTarget(
        self,
        action: #selector(handleCollectionViewPanGesture(_:)))

    // Action bar.
    actionBar.button.addTarget(self, action: #selector(actionBarButtonPressed), for: .touchUpInside)
    actionBar.button.isEnabled = false
    actionBar.button.accessibilityLabel = String.addPictureNoteContentDescription
    actionBar.translatesAutoresizingMaskIntoConstraints = false
    actionBar.setContentHuggingPriority(.defaultHigh, for: .vertical)
    actionBarWrapper.addSubview(actionBar)
    actionBar.topAnchor.constraint(equalTo: actionBarWrapper.topAnchor).isActive = true
    actionBar.leadingAnchor.constraint(equalTo: actionBarWrapper.leadingAnchor).isActive = true
    actionBar.trailingAnchor.constraint(equalTo: actionBarWrapper.trailingAnchor).isActive = true

    actionBarWrapper.backgroundColor = DrawerView.actionBarBackgroundColor
    actionBarWrapper.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(actionBarWrapper)
    actionBarWrapper.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    actionBarWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    actionBarWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    actionBarWrapperHeightConstraint =
        actionBarWrapper.heightAnchor.constraint(equalTo: actionBar.heightAnchor)
    actionBarWrapperHeightConstraint?.isActive = true

    if FeatureFlags.isActionAreaEnabled {
      // We don't use the action bar but it has dependencies elsewhere in the code and we still
      // need to support that until cleanup, so just hide it for now.
      actionBarWrapper.isHidden = true

      view.addSubview(sendFAB)
      sendFAB.accessibilityLabel = String.addPictureNoteContentDescription
      sendFAB.setImage(Metrics.sendFABImage, for: .normal)
      sendFAB.contentEdgeInsets = Metrics.sendFABContentInsets
      sendFAB.disabledAlpha = Metrics.sendFABDisabledAlpha
      sendFAB.addTarget(self, action: #selector(actionBarButtonPressed), for: .touchUpInside)
      sendFAB.translatesAutoresizingMaskIntoConstraints = false
      sendFAB.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                      constant: -1 * Metrics.sendFABPadding).isActive = true
      sendFAB.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                        constant: -1 * Metrics.sendFABPadding).isActive = true
    }

    // Disabled view.
    view.addSubview(disabledView)
    disabledView.translatesAutoresizingMaskIntoConstraints = false
    disabledView.pinToEdgesOfView(view)
    disabledView.isHidden = true

    // Collection view content inset.
    collectionView.contentInset.bottom =
        actionBar.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    collectionView.scrollIndicatorInsets = collectionView.contentInset
  }

  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateDisabledView()
    updateCollectionViewScrollEnabled()
    deselectAllPhotoAssets()
  }

  override open func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if photoLibraryDataSource.startObserving() {
      collectionView.reloadData()
    }
  }

  override open func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    updateDisabledView()
    photoLibraryDataSource.stopObserving()
    isSingleSelectionInProgress = false
  }

  override open func viewWillTransition(to size: CGSize,
                                        with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { (_) in
      self.collectionView.visibleCells.forEach({ (cell) in
        if let photoLibraryCell = cell as? PhotoLibraryCell {
          photoLibraryCell.setImageDimensionConstraints(with: self.itemSize)
        }
      })
      self.collectionView.collectionViewLayout.invalidateLayout()
    }, completion: nil)
  }

  override open func viewSafeAreaInsetsDidChange() {
    actionBarWrapperHeightConstraint?.constant = view.safeAreaInsetsOrZero.bottom
  }

  override func setCustomTint(_ customTint: CustomTint) {
    super.setCustomTint(customTint)
    sendFAB.imageView?.tintColor = customTint.primary
    sendFAB.backgroundColor = customTint.secondary
  }

  // MARK: - PhotoLibraryDataSourceDelegate

  func photoLibraryDataSourceLibraryDidChange(changes: PHFetchResultChangeDetails<PHAsset>?) {
    // Deselect all selected photos.
    deselectAllPhotoAssets()

    guard let changes = changes else { collectionView.reloadData(); return }
    // If there are incremental diffs, animate them in the collection view.
    collectionView.performBatchUpdates({
      // For indexes to make sense, updates must be in this order:
      // delete, insert, reload, move
      if let removed = changes.removedIndexes, !removed.isEmpty {
        self.collectionView.deleteItems(at: removed.map { IndexPath(item: $0, section: 0) })
      }
      if let inserted = changes.insertedIndexes, !inserted.isEmpty {
        self.collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section: 0) })
      }
      if let changed = changes.changedIndexes, !changed.isEmpty {
        self.collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section: 0) })
      }
      changes.enumerateMoves { fromIndex, toIndex in
        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                     to: IndexPath(item: toIndex, section: 0))
      }
    })
  }

  func photoLibraryDataSourcePermissionsDidChange(accessGranted: Bool) {
    guard accessGranted else { return }
    photoLibraryDataSource.fetch()
    collectionView.reloadData()
    updateDisabledView()
  }

  // MARK: - UICollectionViewDataSource

  public func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
    return photoLibraryDataSource.numberOfPhotoAssets
  }

  public func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PhotoLibraryViewController.reuseIdentifier, for: indexPath)
    if let photoLibraryCell = cell as? PhotoLibraryCell {
      photoLibraryCell.delegate = self
      photoLibraryCell.setImageDimensionConstraints(with: itemSize)
      photoLibraryDataSource.thumbnailImageForPhotoAsset(
          at: indexPath,
          withSize: itemSize.applying(scale: traitCollection.displayScale),
          contentMode: .aspectFill) {
        guard let image = $0 else { return }
        photoLibraryCell.image = image
      }

      // If this cell is for the photo asset that is selected, show the highlight.
      if isPhotoAssetSelected(at: indexPath) {
        photoLibraryCell.isSelected = true
      }

      // If there is a download in progress for this cell's photo asset, show the spinner.
      let download = photoLibraryDataSource.isDownloadInProgress(for: indexPath)
      if download.hasDownload {
        photoLibraryCell.startSpinner(withProgress: download.progress)
      }
    }
    return cell
  }

  public func collectionView(_ collectionView: UICollectionView,
                             willDisplay cell: UICollectionViewCell,
                             forItemAt indexPath: IndexPath) {
    guard let photoLibraryCell = cell as? PhotoLibraryCell else { return }
    addDownloadProgressListener(for: photoLibraryCell, at: indexPath)
  }

  public func collectionView(_ collectionView: UICollectionView,
                             didEndDisplaying cell: UICollectionViewCell,
                             forItemAt indexPath: IndexPath) {
    photoLibraryDataSource.removeDownloadProgressListener(for: indexPath)
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0,
                        left: view.safeAreaInsetsOrZero.left,
                        bottom: 0,
                        right: view.safeAreaInsetsOrZero.right)
  }

  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
    return itemSize
  }

  // MARK: - DrawerItemViewController

  public func setUpDrawerPanner(with drawerViewController: DrawerViewController) {
    drawerPanner = DrawerPanner(drawerViewController: drawerViewController,
                                scrollView: collectionView)
  }

  public func reset() {
    collectionView.scrollToTop()
  }

  // MARK: - DrawerPositionListener

  public func drawerViewController(_ drawerViewController: DrawerViewController,
                                   didChangeDrawerPosition position: DrawerPosition) {
    updateCollectionViewScrollEnabled()
  }

  public func drawerViewController(_ drawerViewController: DrawerViewController,
                                   didPanBeyondBounds panDistance: CGFloat) {
    collectionView.contentOffset = CGPoint(x: 0, y: panDistance)
  }

  public func drawerViewController(_ drawerViewController: DrawerViewController,
                                   willChangeDrawerPosition position: DrawerPosition) {
    // If the content offset of the scroll view is within the first four cells, scroll to the top
    // when the drawer position changes to anything but open full.
    let fourCellsHeight = itemSize.height * 4
    let isContentOffsetWithinFirstFourCells = collectionView.contentOffset.y < fourCellsHeight
    if isContentOffsetWithinFirstFourCells && !drawerViewController.isPositionOpenFull(position) {
      perform(#selector(setCollectionViewContentOffsetToZero), with: nil, afterDelay: 0.01)
    }
  }

  public func drawerViewController(_ drawerViewController: DrawerViewController,
                                   isPanningDrawerView drawerView: DrawerView) {}

  // MARK: - UIScrollViewDelegate

  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    drawerPanner?.scrollViewWillBeginDragging(scrollView)
  }

  public func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                       willDecelerate decelerate: Bool) {
    drawerPanner?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
  }

  // MARK: - PhotoLibraryCellDelegate

  // Photo selection is async, we enforce single selection by setting an in-progress
  // state that only gets unset after the async method completes.
  private var isSingleSelectionInProgress = false

  func photoLibraryCellDidSelectImage(_ photoLibraryCell: PhotoLibraryCell) {
    if selectionMode == .single {
      if isSingleSelectionInProgress {
        return
      } else {
        isSingleSelectionInProgress = true
      }
    }

    guard let indexPath = collectionView.indexPath(for: photoLibraryCell) else { return }

    // A photo asset is deselected when it was selected and is tapped again.
    let isPhotoAssetAlreadySelected = isPhotoAssetSelected(at: indexPath)

    switch selectionMode {
    case .single:
      // When in single selection mode, selecting an image
      // should deselect the previously selected one, if any.
      if isPhotoAssetAlreadySelected,
        let selectedImage = selectedImages.first {
        // If the photo is already selected, just deselect it.
        deselectPhotoAsset(selectedImage.asset)
        updateTitle()
        isSingleSelectionInProgress = false
      } else {
        // Otherwise, select a the new cell, and deselect the old one, if any.
        let previouslySelectedImage = self.selectedImages.first

        selectCell(photoLibraryCell, at: indexPath) {
          if let previouslySelectedImage = previouslySelectedImage {
            self.deselectPhotoAsset(previouslySelectedImage.asset)
          }
          self.updateTitle()
          self.isSingleSelectionInProgress = false
        }
      }
    case .multiple:
      // When in multiple selection mode, selecting an image
      // does not deselect any other selected ones.
      if isPhotoAssetAlreadySelected {
        if let photoAsset = photoLibraryDataSource.photoAsset(for: indexPath) {
          // If the photo is already selected, deselect it.
          deselectPhotoAsset(photoAsset)
          updateTitle()
        }
      } else {
        // If the photo is not already selected, select it.
        selectCell(photoLibraryCell, at: indexPath) {
          self.updateTitle()
        }
      }
    }
  }

  /// Sets a `PhotoLibraryCell`'s selected state to true.
  func selectCell(
    _ photoCell: PhotoLibraryCell,
    at indexPath: IndexPath,
    completion: @escaping (() -> Void)) {

    _ = photoLibraryDataSource.imageForPhotoAsset(
      at: indexPath,
      downloadDidBegin: {
        photoCell.startSpinner()
    },
      completion: { (image, metadata, photoAsset) in
        if let photoAsset = photoAsset,
          let image = image,
          let indexPath = self.photoLibraryDataSource.indexPathOfPhotoAsset(photoAsset) {
          let selectedImage = SelectedImage(asset: photoAsset, image: image, metadata: metadata)
          self.selectedImages.append(selectedImage)
          self.collectionView.cellForItem(at: indexPath)?.isSelected = true
          completion()
        }
    })
  }

  // MARK: - Gesture recognizer

  @objc func handleCollectionViewPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
    drawerPanner?.handlePanGesture(panGestureRecognizer)
  }

  // MARK: - Private

  // Update the state and contents of the disabled view based on permissions or camera allowance.
  private func updateDisabledView() {
    if !photoLibraryDataSource.isPhotoLibraryPermissionGranted {
      disabledView.isHidden = false
      disabledView.shouldDisplayActionButton = true
      disabledView.messageLabel.text = String.inputPhotoLibraryPermissionDenied
      disabledView.actionButton.setTitle(String.inputBlockedOpenSettingsButton, for: .normal)
      disabledView.actionButton.addTarget(self,
                                          action: #selector(openLibrarySettingsPressed),
                                          for: .touchUpInside)
    } else {
      disabledView.isHidden = true
    }
  }

  @objc private func openLibrarySettingsPressed() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(settingsURL)
  }

  @objc private func setCollectionViewContentOffsetToZero() {
    collectionView.setContentOffset(.zero, animated: true)
  }

  private func updateCollectionViewScrollEnabled() {
    // The collection view scrolling should be disabled when in a drawer, unless voiceover mode is
    // running or the drawer is open full.
    var shouldEnableScroll: Bool {
      guard let drawerViewController = drawerViewController else { return true }
      return drawerViewController.isOpenFull || UIAccessibility.isVoiceOverRunning
    }

    collectionView.isScrollEnabled = shouldEnableScroll
  }

  private func deselectAllPhotoAssets() {
    selectedImages = []
    updateTitle()
    collectionView.reloadData()
  }

  private func deselectPhotoAsset(_ photoAsset: PHAsset) {
    // Get an array of just the selected assets, so we can compare against the newly selected asset.
    let selectedPhotoAssets = selectedImages.map { $0.asset }
    if selectedPhotoAssets.contains(photoAsset),
      let indexPath =
      photoLibraryDataSource.indexPathOfPhotoAsset(photoAsset) {
      collectionView.cellForItem(at: indexPath)?.isSelected = false
      selectedImages.removeAll(where: { $0.asset == photoAsset })
    }
  }

  private func addDownloadProgressListener(for photoLibraryCell: PhotoLibraryCell,
                                           at indexPath: IndexPath) {
    photoLibraryDataSource.setDownloadProgressListener(for: indexPath) {
        (progress, error, complete) in
      if let error = error {
        photoLibraryCell.stopSpinner()
        print("[PhotoLibraryViewController] Error downloading image: \(error.localizedDescription)")
      } else if complete {
        photoLibraryCell.stopSpinner()
      } else {
        photoLibraryCell.setSpinnerProgress(progress)
      }
    }
  }

  // Whether or not the photo asset displayed at an index path is a selected photo asset.
  private func isPhotoAssetSelected(at indexPath: IndexPath) -> Bool {
    guard let photoAsset = photoLibraryDataSource.photoAsset(for: indexPath) else { return false }
    // Get an array of just the selected assets, so we can compare against the newly selected asset.
    let selectedPhotoAssets = selectedImages.map { $0.asset }
    return selectedPhotoAssets.contains(photoAsset)
  }

  private func updateTitle() {
    guard !selectedImages.isEmpty else {
      title = String.actionAreaGalleryPhotosSelected
      return
    }
    let count = String(selectedImages.count)
    title = String(format: String.actionAreaGalleryMultiplePhotosSelected, count)
  }

  // MARK: - User actions

  @objc private func actionBarButtonPressed() {
    guard !selectedImages.isEmpty else { return }

    func createPhotoNote() {
      // Get data for all selected images which successfully compress.
      let imageDatas: [(imageData: Data, metadata: NSDictionary?)] =
        selectedImages.compactMap { selectedImage in
          guard let jpegData = selectedImage.image.jpegData(compressionQuality: 0.8) else {
            return nil
          }
          return (jpegData, selectedImage.metadata)
      }
      // If we're missing an imageData, it's because jpg compression failed.
      guard imageDatas.count == selectedImages.count else {
        print("[PhotoLibraryViewController] Error creating image data.")
        return
      }
      self.delegate?.imageSelectorDidCreateImageData(imageDatas)
      self.deselectAllPhotoAssets()
    }

    // If the drawer will be animating, create the photo note after the animation completes.
    if let drawerViewController = drawerViewController {
      drawerViewController.minimizeFromFull(completion: {
        createPhotoNote()
      })
    } else {
      createPhotoNote()
    }
  }

  // MARK: - Notifications

  @objc private func accessibilityVoiceOverStatusChanged() {
    updateCollectionViewScrollEnabled()
  }

}

// swiftlint:enable type_body_length
