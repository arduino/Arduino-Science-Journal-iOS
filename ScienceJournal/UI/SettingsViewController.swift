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
import MaterialComponents.MaterialSnackbar

#if SCIENCEJOURNAL_DEV_BUILD || SCIENCEJOURNAL_DOGFOOD_BUILD
public extension Notification.Name {
  /// Posted when root data should be created to test the claim flow.
  static let DEBUG_createRootUserData = NSNotification.Name("GSJ_DEBUG_CreateRootUserData")
  /// Posted when the current user should now be destroyed.
  static let DEBUG_destroyCurrentUser = NSNotification.Name("GSJ_DEBUG_DestroyCurrentUser")
  /// Posted when auth should be forced to test the migration flow.
  static let DEBUG_forceAuth = NSNotification.Name("GSJ_DEBUG_ForceAuth")
}
#endif  // SCIENCEJOURNAL_DEV_BUILD || SCIENCEJOURNAL_DOGFOOD_BUILD

/// A view controller that presents users with a list of various settings.
class SettingsViewController: MaterialHeaderCollectionViewController {

  // MARK: - Data model

  enum SettingsItemType {
    case settingButton
    case settingSwitch
  }
  
  enum SettingsItemAccessory {
    case button(_ action: Selector, _ title: String)
    case `switch`(_ action: Selector, _ inOn: Bool)
  }
  
  enum SettingsItem {
    case header(_ text: String)
    case separator
    case item(_ title: String, _ subtitle: String?, _ accessory: SettingsItemAccessory?)
    
    var height: CGFloat {
      switch self {
      case .header: return 52
      case .item: return 52
      case .separator: return 9
      }
    }
  }
  
  // MARK: - Constants

  let headerCellIdentifier = "SettingsHeaderCell"
  let separatorCellIdentifier = "SettingsSeparatorCell"
  let itemCellIdentifier = "SettingsItemCell"

  // MARK: - Properties

  private var rows: [SettingsItem] = []
  private let driveSyncManager: DriveSyncManager?
  private let accountsManager: AccountsManager
  private let userManager: UserManager
  private let preferenceManager: PreferenceManager

  // MARK: - Public

  /// Designated initializer.
  ///
  /// - Parameters:
  ///   - analyticsReporter: The analytics reporter.
  ///   - driveSyncManager: The drive sync manager.
  ///   - preferenceManager: The preference manager.
  init(analyticsReporter: AnalyticsReporter,
       driveSyncManager: DriveSyncManager?,
       accountsManager: AccountsManager,
       userManager: UserManager,
       preferenceManager: PreferenceManager) {
    self.preferenceManager = preferenceManager
    self.driveSyncManager = driveSyncManager
    self.accountsManager = accountsManager
    self.userManager = userManager
    super.init(analyticsReporter: analyticsReporter)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Always register collection view cells early to avoid a reload occurring first.
    collectionView?.register(SettingsHeaderCell.self,
                             forCellWithReuseIdentifier: headerCellIdentifier)
    collectionView?.register(SettingsSeparatorCell.self,
                             forCellWithReuseIdentifier: separatorCellIdentifier)
    collectionView?.register(SettingsItemCell.self,
                             forCellWithReuseIdentifier: itemCellIdentifier)
    
    styler.cellStyle = .default
    collectionView?.backgroundColor = .white

    title = String.navigationItemSettings

    if isPresented {
      appBar.hideStatusBarOverlay()
      let closeMenuItem = MaterialCloseBarButtonItem(target: self,
                                                     action: #selector(closeButtonPressed))
      navigationItem.leftBarButtonItem = closeMenuItem
    } else {
      let backMenuItem = MaterialBackBarButtonItem(target: self,
                                                   action: #selector(backButtonPressed))
      navigationItem.leftBarButtonItem = backMenuItem
    }

    addSignOutButton()
    configureSettingsItems()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(close),
                                           name: .userWillBeSignedOut,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(configureSettingsItems),
                                           name: .driveSyncDidEnable,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(configureSettingsItems),
                                           name: .driveSyncDidDisable,
                                           object: nil)
  }

  // MARK: - Private

  private func addSignOutButton() {
    let button = WizardButton(title: String.settingsSignOutButton,
                              style: .outlined,
                              size: .big)
    button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    
    let buttonContainer = UIView()
    buttonContainer.backgroundColor = view.backgroundColor
    buttonContainer.addSubview(button)
    view.addSubview(buttonContainer)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    buttonContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
      button.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 28),
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -28),
      buttonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      buttonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  @objc private func close() {
    if isPresented {
      closeButtonPressed()
    } else {
      backButtonPressed()
    }
  }
  
  // Configure each setting item and add it to the data source.
  @objc private func configureSettingsItems() {
    rows.removeAll()

    if let account = accountsManager.currentAccount {
      rows.append(.header("Arduino Account"))
      rows.append(.item(account.displayName, account.email, nil))
      
      if account.supportsDriveSync {
        rows.append(.separator)
        rows.append(.header("Google Drive Sync"))
        rows.append(.item("Enable Drive Sync",
                          nil,
                          .switch(#selector(toggleDriveSync), userManager.isDriveSyncEnabled)))
        
        if let email = preferenceManager.driveSyncUserEmail {
          rows.append(.item("Account", email, .none))
        }
        
        if let folder = preferenceManager.driveSyncFolderName {
          rows.append(.item("Sync Folder",
                            folder,
                            .button(#selector(setupDriveSync), "CHANGE")))
        }
      }
    }
    
    collectionView.reloadData()
  }

  // MARK: - User Actions

  @objc private func backButtonPressed() {
    navigationController?.popViewController(animated: true)
  }

  @objc private func closeButtonPressed() {
    dismiss(animated: true)
  }
  
  @objc private func signOut() {
    accountsManager.signOutCurrentAccount()
  }

  // MARK: - Settings Actions

  @objc private func toggleDriveSync() {
    if userManager.isDriveSyncEnabled {
      accountsManager.disableDriveSync()
    } else {
      setupDriveSync()
    }
  }
  
  @objc private func setupDriveSync() {
    accountsManager.setupDriveSync(fromViewController: self)
  }
  
  @objc private func dataUsageSwitchChanged(sender: UISwitch) {
    let isOptedOut = !sender.isOn
    preferenceManager.hasUserOptedOutOfUsageTracking = isOptedOut
    analyticsReporter.setOptOut(isOptedOut)
  }

  // MARK: - UICollectionViewDataSource

  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return rows.count
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let settingItem = rows[indexPath.row]
    
    // swiftlint:disable force_cast
    switch settingItem {
    case .header(let text):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellIdentifier,
                                                    for: indexPath) as! SettingsHeaderCell
      cell.textLabel.text = text
      return cell
    case .separator:
      return collectionView.dequeueReusableCell(withReuseIdentifier: separatorCellIdentifier,
                                                for: indexPath)
    case .item(let title, let subtitle, let accessory):
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellIdentifier,
                                                    for: indexPath) as! SettingsItemCell
      cell.titleLabel.text = title
      cell.subtitleLabel.text = subtitle
      
      switch accessory {
      case .button(let action, let title):
        let button = WizardButton(title: title, style: .system, size: .regular)
        button.addTarget(self, action: action, for: .touchUpInside)
        cell.accessoryView = button
      case .switch(let action, let isOn):
        let switchControl = UISwitch()
        switchControl.addTarget(self, action: action, for: .valueChanged)
        switchControl.onTintColor = ArduinoColorPalette.tealPalette.tint800
        switchControl.isOn = isOn
        cell.accessoryView = switchControl
      default: break
      }
      return cell
    }
    // swiftlint:enable force_cast
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
    let settingsItem = rows[indexPath.row]
    let viewWidth = collectionView.bounds.size.width - view.safeAreaInsetsOrZero.left -
        view.safeAreaInsetsOrZero.right
    return CGSize(width: viewWidth, height: settingsItem.height)
  }
}
