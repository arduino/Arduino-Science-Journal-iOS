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

import MaterialComponents.MaterialButtonBar
import MaterialComponents.MaterialShadowLayer

// MARK: - ActionArea.BarViewController

extension ActionArea {

  /// The bar where items are displayed.
  final class BarViewController: ContentContainerViewController {

    enum Metrics {
      enum ActionButton {
        static let size: CGFloat = 48
        static let toLabelSpacing: CGFloat = 4
      }

      enum Bar {
        static let backgroundColor = UIColor.white
        static let buttonTitleColor: UIColor = ArduinoColorPalette.grayPalette.tint800 ?? .gray
        static let cornerRadius: CGFloat = 15
        static let defaultMargins = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
        static let disabledAlpha: CGFloat = 0.2
        static let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let shadow = MDCShadowMetrics(elevation: ShadowElevation.fabResting.rawValue)
        static let toFABSpacing: CGFloat = 8
      }
    }

    /// Transitions related to the bar and actions.
    enum TransitionType {

      /// Raise the bar with the specified actions.
      case raise(with: ActionItem, isEnabled: Bool)

      /// Update the bar with the specified actions.
      case update(with: ActionItem, isEnabled: Bool)

      /// Enable or disable the bar.
      case enable(Bool)

      /// Lower the bar and clear the actions.
      case lower

    }

    // MARK: - Initializers

    // MARK: - Implementation

    /// The `ActionItem` to display in the Action Area Bar.
    private var actionItem: ActionItem = .empty

    private var primary: UIButton? {
      didSet {
        oldValue?.removeFromSuperview()
      }
    }

    private var barHeightFromBottomEdge: CGFloat {
      return view.bounds.height - bar.frame.minY
    }

    private var currentAlpha: CGFloat {
      switch (actionItem.isEmpty, isEnabled) {
      case (true, false), (true, true):
        return 0
      case (false, true):
        return 1
      case (false, false):
        return Metrics.Bar.disabledAlpha
      }
    }

    /// Enable or disable the bar.
    private var isEnabled: Bool = true {
      didSet {
        primary?.isUserInteractionEnabled = isEnabled
        bar.isUserInteractionEnabled = isEnabled
      }
    }

    private var bar: Bar = {
      let view = Bar()
      view.clipsToBounds = false
      view.layer.shadowRadius = 12
      view.layer.shadowOffset = CGSize(width: 0, height: 4)
      view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
      view.alpha = 0
      return view
    }()

    private func create(primary: BarButtonItem) -> UIButton {
      let button = MDCFloatingButton()
      button.mode = .expanded
      button.isUppercaseTitle = false
      button.setTitle(primary.title, for: .normal)
      button.setImage(primary.image, for: .normal)
      button.setTitleColor(.black, for: .normal)
      button.setBackgroundColor(.white, for: .normal)
      let insets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
      button.setContentEdgeInsets(insets, for: .default, in: .expanded)
      button.addTarget(primary, action: #selector(BarButtonItem.execute), for: .touchUpInside)

      button.layoutIfNeeded()
      view.addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: -1 * Metrics.Bar.toFABSpacing).isActive = true
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

      return button
    }

    private func updateAdditionalSafeAreaInsets() {
      if bar.alpha > 0 {
        content.additionalSafeAreaInsets =
          UIEdgeInsets(top: 0,
                       left: 0,
                       bottom: barHeightFromBottomEdge - view.safeAreaInsets.bottom,
                       right: 0)
      } else {
        content.additionalSafeAreaInsets = .zero
      }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
      super.viewDidLoad()

      // TODO: Figure out how to do this dynamically. Ideally we would get these from the margins
      // of the content view controller, but they're not what we want.
      view.layoutMargins = Metrics.Bar.defaultMargins
      // Ignore system mimimums because we want to use our custom margins.
      viewRespectsSystemMinimumLayoutMargins = false
      // Inset the layout margins from the edge, so we can keep the bar as close to the edge as
      // possible.
      view.insetsLayoutMarginsFromSafeArea = false

      view.addSubview(bar)
      bar.translatesAutoresizingMaskIntoConstraints = false
      bar.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
      let leading = bar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
      leading.priority = .defaultHigh
      leading.isActive = true
      
      bar.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
      let trailing = bar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
      trailing.priority = .defaultHigh
      trailing.isActive = true
      
      bar.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
      let bottom = bar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      bottom.priority = .defaultHigh
      bottom.isActive = true
    }

    // MARK: - Transitions

    /// Elevate or flatten the bar.
    var barIsElevated: Bool = true {
      didSet {
        guard oldValue != barIsElevated else { return }

        let barAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        let toValue: Float
        if barIsElevated {
          toValue = Metrics.Bar.shadow.bottomShadowOpacity
        } else {
          toValue = 0
        }
        barAnimation.fromValue = bar.layer.shadowOpacity
        barAnimation.toValue = toValue
        bar.layer.shadowOpacity = toValue
        bar.layer.add(barAnimation, forKey: "barAnimation")
      }
    }

    func transition(
      _ type: TransitionType,
      coordinator: UIViewControllerTransitionCoordinator?,
      animator: UIViewPropertyAnimator?
    ) {
      switch type {
      case let .raise(with: newActionItem, isEnabled: isEnabled):
        actionItem = newActionItem
        bar.items = newActionItem.items
        primary = newActionItem.primary.map(create(primary:))
        view.layoutIfNeeded()
        self.isEnabled = isEnabled

        transition(before: {
          self.bar.transform = CGAffineTransform(translationX: 0, y: self.barHeightFromBottomEdge)
        }, during: {
          self.bar.transform = .identity
          self.primary?.alpha = self.currentAlpha
          self.bar.alpha = self.currentAlpha
          self.updateAdditionalSafeAreaInsets()
        }, after: {}, coordinator: coordinator, animator: animator)
      case let .update(with: newActionItem, isEnabled: isEnabled):
        // We can get an equivalent item when the AA is in the `modal` state in portrait orientation
        // and the modal content VC is hidden or re-shown, which will result in undesired animation.
        guard actionItem != newActionItem else { return }

        actionItem = newActionItem
        self.isEnabled = isEnabled

        let newPrimary = newActionItem.primary.map(create(primary:))
        transition(from: primary, to: newPrimary, coordinator: coordinator, animator: animator)
        transition(to: newActionItem.items, coordinator: coordinator, animator: animator)
      case let .enable(isEnabled):
        transition(before: {
          self.isEnabled = isEnabled
        }, during: {
          self.primary?.alpha = self.currentAlpha
          self.bar.alpha = self.currentAlpha
          self.updateAdditionalSafeAreaInsets()
        }, after: {}, coordinator: coordinator, animator: animator)
      case .lower:
        transition(before: {}, during: {
          self.bar.transform = CGAffineTransform(translationX: 0, y: self.barHeightFromBottomEdge)
          self.updateAdditionalSafeAreaInsets()
        }, after: {
          self.bar.transform = .identity
          self.actionItem = .empty
          self.bar.items = []
          self.bar.alpha = self.currentAlpha
          self.primary = nil
        }, coordinator: coordinator, animator: animator)
      }
    }

    private func transition(
      to items: [BarButtonItem],
      coordinator: UIViewControllerTransitionCoordinator?,
      animator: UIViewPropertyAnimator?
    ) {
      guard !items.isEmpty else {
        transition(during: {
          self.bar.alpha = self.currentAlpha
          self.updateAdditionalSafeAreaInsets()
        }, coordinator: coordinator, animator: animator)
        return
      }

      // TODO:
      //   Revisit this animation. The current approach performs much better than replacing the
      //   bar, but it won't handle transitions where the action descriptions have different
      //   numbers of lines.
      let snapshot = bar.snapshotView(afterScreenUpdates: false)
      transition(before: {
        if let snapshot = snapshot {
          bar.superview?.addSubview(snapshot)
          snapshot.frame = bar.frame
        }
        bar.alpha = 0
        bar.items = items
      }, during: {
        snapshot?.alpha = 0
        self.bar.alpha = self.currentAlpha
        self.updateAdditionalSafeAreaInsets()
      }, after: {
        snapshot?.removeFromSuperview()
      }, coordinator: coordinator, animator: animator)
    }

    private func transition(
      from: UIButton?,
      to: UIButton?,
      coordinator: UIViewControllerTransitionCoordinator?,
      animator: UIViewPropertyAnimator?
    ) {
      switch (from, to) {
      case (.none, .none):
        break
      case let (.some(from), .none):
        transition(during: {
          from.alpha = 0
        }, after: {
          self.primary = nil
        }, coordinator: coordinator, animator: animator)
      case let (.none, .some(to)):
        transition(before: {
          to.alpha = 0
        }, during: {
          to.alpha = 1
        }, after: {
          self.primary = to
        }, coordinator: coordinator, animator: animator)
      case let (.some(from), .some(to)):
        transition(before: {
          to.alpha = 0
          // this is needed to prevent a glitch
          to.layoutIfNeeded()
        }, during: {
          UIView.animateKeyframes(withDuration: 0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
              from.titleLabel?.alpha = 0
              from.imageView?.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4) {
              let x = to.bounds.width / from.bounds.width
              from.transform = CGAffineTransform(scaleX: x, y: 1)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
              from.alpha = 0
              to.alpha = 1
            }
          })
        }, after: {
          self.primary = to
        }, coordinator: coordinator, animator: animator)
      }
    }

    private func transition(
      before: () -> Void = {},
      during: @escaping () -> Void = {},
      after: @escaping () -> Void = {},
      coordinator: UIViewControllerTransitionCoordinator?,
      animator: UIViewPropertyAnimator?
    ) {
      if let coordinator = coordinator, coordinator.isAnimated {
        before()
        coordinator.animateAlongsideTransition(in: view, animation: { _ in
          during()
        }) { _ in
          after()
        }
      } else if let animator = animator, animator.state == .active {
        before()
        animator.addAnimations(during)
        animator.addCompletion({ _ in after() })
      } else {
        before()
        during()
        after()
      }
    }

    // MARK: - Descriptions

    override var description: String {
      return "ActionArea.\(type(of: self))"
    }

    override var debugDescription: String {
      return "ActionArea.\(type(of: self))(content: \(content))"
    }

  }

}

// MARK: - ActionArea.BarViewController+CustomTintable

extension ActionArea.BarViewController {
  override func setCustomTint(_ customTint: CustomTint) {
    super.setCustomTint(customTint)

    // FIXME: Workaround to allow tinting only when in recording mode
    if customTint.primary.isEqual(UIColor.trialHeaderRecordingBackgroundColor) {
      bar.setCustomTint(customTint)
    } else {
      let defaultTint = CustomTint(primary: ArduinoColorPalette.iconColor,
                                   secondary: ArduinoColorPalette.containerBackgroundColor)
      bar.setCustomTint(defaultTint)
    }

  }
}

// MARK: - ActionArea.Bar

extension ActionArea {

  private final class Bar: UIView, CustomTintable {

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }

    private let keyTint = KeyTint()

    func setCustomTint(_ customTint: CustomTint) {
      keyTint.customTint = customTint
      keyTint.apply(to: buttons)
    }

    private let stackView: UIStackView = {
      let view = UIStackView()
      view.axis = .horizontal
      view.alignment = .firstBaseline
      view.distribution = .fillEqually
      // The stack view needs at least one view to calculate its intrinsic content size.
      view.addArrangedSubview(UIView())
      return view
    }()

    private var buttons: [BarButton] = [] {
      didSet {
        keyTint.apply(to: buttons)
      }
    }

    var items: [BarButtonItem] = [] {
      didSet {
        stackView.removeAllArrangedViews()
        buttons = items.map { BarButton(item: $0) }
        buttons.forEach { button in
          stackView.addArrangedSubview(button)
        }
        (stackView.arrangedSubviews.count ..< 4).forEach { _ in
          stackView.addArrangedSubview(UIView())
        }
      }
    }

    override init(frame: CGRect) {
      super.init(frame: frame)
      addSubview(stackView)
      backgroundColor = BarViewController.Metrics.Bar.backgroundColor
      layer.cornerRadius = BarViewController.Metrics.Bar.cornerRadius
      layer.masksToBounds = true
      layoutMargins = BarViewController.Metrics.Bar.padding
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
      stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
      stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
      stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

  }

}

// MARK: - ActionArea.BarButton

extension ActionArea {

  private final class BarButton: UIView, CustomTintable {

    override class var requiresConstraintBasedLayout: Bool {
      return true
    }

    private let button: UIButton = {
      let view = UIButton(type: .custom)
      view.layer.cornerRadius = BarViewController.Metrics.ActionButton.size / 2
      view.clipsToBounds = true
      return view
    }()

    private let label: UILabel = {
      let view = UILabel()
      view.numberOfLines = 2
      view.textAlignment = .center
      view.textColor = BarViewController.Metrics.Bar.buttonTitleColor
      view.font = ArduinoTypography.regularFont(forSize: ArduinoTypography.FontSize.XSmall.rawValue)
      return view
    }()

    private let item: BarButtonItem
    private var _intrinsicContentSize: CGSize = .zero

    init(item: BarButtonItem) {
      self.item = item
      super.init(frame: .zero)

      translatesAutoresizingMaskIntoConstraints = false
      accessibilityHint = item.accessibilityHint

      button.setImage(item.image, for: .normal)
      button.addTarget(item, action: #selector(BarButtonItem.execute), for: .touchUpInside)
      addSubview(button)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.heightAnchor.constraint(equalToConstant: BarViewController.Metrics.ActionButton.size).isActive = true
      button.widthAnchor.constraint(equalToConstant: BarViewController.Metrics.ActionButton.size).isActive = true
      button.topAnchor.constraint(equalTo: topAnchor).isActive = true
      button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
      button.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
      button.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true

      label.text = item.title
      addSubview(label)
      label.translatesAutoresizingMaskIntoConstraints = false
      label.topAnchor.constraint(equalTo: button.bottomAnchor,
                                 constant: BarViewController.Metrics.ActionButton.toLabelSpacing).isActive = true
      label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
      label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
      label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
      label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

      self._intrinsicContentSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
      return _intrinsicContentSize
    }

    func setCustomTint(_ customTint: CustomTint) {
      button.imageView?.tintColor = customTint.primary
      button.backgroundColor = customTint.secondary
    }

  }

}

// MARK: - Debugging

#if DEBUG
extension ActionArea.BarViewController {

  func layoutDebuggingInfo() -> String {
    func v(_ name: String, _ v: UIView, _ message: inout String) {
      message += "  \(name).frame: \(v.frame)\n"
      message += "  \(name).bounds: \(v.bounds)\n"
      message += "  \(name).layoutMargins: \(v.layoutMargins)\n"
      message += "  \(name).safeAreaInsets: \(v.safeAreaInsets)\n"
      message += "  \(name).preservesSuperviewLayoutMargins: \(v.preservesSuperviewLayoutMargins)\n"
      message += "  \(name).insetsLayoutMarginsFromSafeArea: \(v.insetsLayoutMarginsFromSafeArea)\n"
    }

    func vc(_ name: String, _ vc: UIViewController, _ message: inout String) {
      v("\(name).view", vc.view, &message)
      message += "  \(name).viewRespectsSystemMinimumLayoutMargins: " +
        "\(vc.viewRespectsSystemMinimumLayoutMargins)\n"
      message += "  \(name).additionalSafeAreaInsets: \(vc.additionalSafeAreaInsets)\n"
    }

    var message = "\(type(of: self)).\(#function)\n"
    if let window = view.window {
      message += "  window.safeAreaInsets: \(window.safeAreaInsets)\n"
    }
    vc("barViewController", self, &message)
    v("barViewController.bar", bar, &message)
    vc("barViewController.content", content, &message)

    return message
  }

}
#endif
