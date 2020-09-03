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

extension ActionArea {

  /// A container for detail content view controllers in the Action Area.
  final class DetailContentContainerViewController: ContentContainerViewController, DetailContent {

    /// The mode for this content.
    let mode: ContentMode

    /// The close button item, if the content view controller has one.
    let closeButtonItem: UIBarButtonItem?

    let barElevator: FeatureEnabler?

    // TODO: Remove when `childForStatusBarStyle` works.
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    private var currentLeftBarButtonItem: UIBarButtonItem?
    private var originalContentHidesBackButton: Bool = false

    // MARK: - MaterialHeader

    override var hasMaterialHeader: Bool { return true }

    // MARK: - Initializers

    /// Designated initializer.
    ///
    /// - Parameters:
    ///   - content: The content view controller.
    ///   - closeButtonItem: The content view controller's close button item.
    ///   - outsideOfSafeAreaKeyPath: The `KeyPath` of the property that indicates if the content is
    ///     outside of the safe area.
    ///   - mode: The mode for this content.
    init<T: UIViewController>(
      content: T,
      closeButtonItem: UIBarButtonItem? = nil,
      outsideOfSafeAreaKeyPath: KeyPath<T, Bool>? = nil,
      mode: ContentMode
    ) {
      self.closeButtonItem = closeButtonItem
      self.barElevator =
        outsideOfSafeAreaKeyPath.map { FeatureEnabler(target: content, keyPath: $0) }
      self.mode = mode

      let vc: UIViewController
      if content.hasMaterialHeader {
        vc = content
      } else {
        let header = MaterialHeaderContainerViewController(content: content)
        vc = header
      }

      super.init(content: vc)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    /// Convenience initializer.
    ///
    /// - Parameters:
    ///   - content: The content view controller.
    ///   - closeButtonItem: The content view controller's close button item.
    ///   - outsideOfSafeAreaKeyPath: The `KeyPath` of the property that indicates if the content is
    ///     outside of the safe area.
    ///   - mode: A block that returns the mode for this content.
    convenience init<T: UIViewController>(
      content: T,
      closeButtonItem: UIBarButtonItem? = nil,
      outsideOfSafeAreaKeyPath: KeyPath<T, Bool>? = nil,
      mode: () -> ContentMode
    ) {
      self.init(
        content: content,
        closeButtonItem: closeButtonItem,
        outsideOfSafeAreaKeyPath:outsideOfSafeAreaKeyPath,
        mode: mode()
      )
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()

      if closeButtonItem == nil {
        assert(
          navigationItem.leftBarButtonItem == nil,
          "Found existing leftBarButtonItem. " +
            "Specify the content's close button via `DetailContent.closeButtonItem`."
        )
        currentLeftBarButtonItem = defaultCloseButtonItem
      } else {
        currentLeftBarButtonItem = closeButtonItem
      }
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      overrideNavigationItem()
    }

    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      restoreNavigationItem()
    }

    // MARK: - Implementation

    override var description: String {
      return "ActionArea.DetailContentContainerViewController(content: \(content))"
    }

    func actionAreaStateDidChange(_ actionAreaController: ActionArea.Controller) {
      assertIsSafeToOverrideLeftBarButtonItem()

      switch actionAreaController.state {
      case .normal:
        currentLeftBarButtonItem = closeButtonItem ?? defaultCloseButtonItem
      case .modal:
        currentLeftBarButtonItem = actionAreaController.isExpanded ? nil : hideButtonItem
      }
      navigationItem.leftBarButtonItem = currentLeftBarButtonItem
    }

    private func overrideNavigationItem() {
      assertIsSafeToOverrideLeftBarButtonItem()

      navigationItem.leftBarButtonItem = currentLeftBarButtonItem

      // The AA detail should never show a back button.
      originalContentHidesBackButton = navigationItem.hidesBackButton
      navigationItem.hidesBackButton = true
    }

    private func assertIsSafeToOverrideLeftBarButtonItem() {
      var isSafeToOverrideLeftBarButtonItem: Bool {
        if navigationItem.leftBarButtonItem == nil { return true }
        if [closeButtonItem, defaultCloseButtonItem, hideButtonItem]
          .contains(navigationItem.leftBarButtonItem) {
          return true
        }
        return false
      }

      assert(
        isSafeToOverrideLeftBarButtonItem,
        "Found unknown leftBarButtonItem: \(String(describing: navigationItem.leftBarButtonItem))"
      )
    }

    private func restoreNavigationItem() {
      navigationItem.leftBarButtonItem = closeButtonItem
      navigationItem.hidesBackButton = originalContentHidesBackButton
    }

    private lazy var defaultCloseButtonItem: UIBarButtonItem = {
      UIBarButtonItem(image: UIImage(named: "ic_close"),
                      style: .plain,
                      target: self,
                      action: #selector(close))
    }()

    private lazy var hideButtonItem: UIBarButtonItem = {
      UIBarButtonItem(image: UIImage(named: "ic_expand_more"),
                      style: .plain,
                      target: self,
                      action: #selector(close))
    }()

    @objc private func close() {
      if let navigationController = navigationController {
        navigationController.popViewController(animated: true)
      } else {
        dismiss(animated: true, completion: nil)
      }
    }

  }

}
