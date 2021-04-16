//  
//  DriveSyncFolderListTableViewController.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 07/01/21.
//  Copyright © 2021 Arduino. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit
import RxSwift

class DriveSyncFolderListTableViewController: UITableViewController {

  let driveFetcher: DriveFetcher
  let folder: DriveFetcher.Folder?
  let selectButton: UIButton

  var subfolders = [DriveFetcher.Folder]()

  private lazy var isLoading = BehaviorSubject(value: false)
  private lazy var isEmpty = BehaviorSubject(value: false)
  
  private lazy var disposeBag = DisposeBag()

  init(driveFetcher: DriveFetcher, folder: DriveFetcher.Folder?, selectButton: UIButton) {
    self.driveFetcher = driveFetcher
    self.folder = folder
    self.selectButton = selectButton
    super.init(style: .plain)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.allowsSelection = true
    tableView.allowsMultipleSelection = false
    tableView.backgroundColor = UIColor.clear
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 74, right: 0)
    tableView.delaysContentTouches = false
    tableView.tableFooterView = UIView()

    tableView.register(Cell.self, forCellReuseIdentifier: "cell")
    
    addObservers()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    selectButton.isEnabled = folder != nil
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fetchFolders()
  }
  
  func add(_ folder: DriveFetcher.Folder) {
    tableView.beginUpdates()
    isEmpty.onNext(false)
    subfolders.append(folder)
    subfolders.sort { $0.name < $1.name }
    guard let index = subfolders.firstIndex(of: folder) else { return }
    let indexPath = IndexPath(row: index, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
    tableView.endUpdates()
    tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    tableView(tableView, didSelectRowAt: indexPath)
  }
  
  func startLoading() {
    isLoading.onNext(true)
  }
  
  func stopLoading() {
    isLoading.onNext(false)
  }
  
  private func fetchFolders() {
    startLoading()
    
    driveFetcher.subfolders(in: folder)
      .withUnretained(self)
      .observe(on: MainScheduler.instance)
      .subscribe { owner, folders in
        owner.tableView.beginUpdates()
        defer { owner.tableView.endUpdates() }
        
        owner.isEmpty.onNext(folders.isEmpty)
        owner.subfolders = folders
        owner.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
      } onError: { _ in

      } onDisposed: { [weak self] in
        self?.stopLoading()
      }
      .disposed(by: disposeBag)
  }
  
  private func addObservers() {
    let tableView = self.tableView
    
    Observable.combineLatest(isLoading, isEmpty)
      .observe(on: MainScheduler.instance)
      .subscribe { isLoading, isEmpty in
        if isLoading {
          tableView?.tableFooterView = ActivityTableFooterView()
        } else if isEmpty {
          tableView?.tableFooterView = EmptyStateView(text: String.driveSyncFolderPickerEmpty)
        } else {
          tableView?.tableFooterView = UIView()
        }
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subfolders.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cell else {
      fatalError("Invalid cell type")
    }
    
    let folder = subfolders[indexPath.row]
    cell.backgroundColor = UIColor.clear
    cell.textLabel?.text = folder.name
    
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showFolder(at: indexPath)
  }
  
  private func showFolder(at indexPath: IndexPath) {
    guard indexPath.row < subfolders.count else { return }
    let folder = subfolders[indexPath.row]
    let viewController = DriveSyncFolderListTableViewController(driveFetcher: driveFetcher,
                                                                folder: folder,
                                                                selectButton: selectButton)
    show(viewController, sender: nil)
  }
}

extension DriveSyncFolderListTableViewController {
  class Cell: UITableViewCell {
    
    private let cellColor = ArduinoColorPalette.grayPalette.tint500
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)

      selectionStyle = .none
      separatorInset = .zero
      textLabel?.font = ArduinoTypography.paragraphFont
      textLabel?.textColor = cellColor
      imageView?.image = UIImage(named: "google_drive_folder")
      imageView?.tintColor = cellColor
      accessoryView = UIImageView(image: UIImage(named: "arduino_navigation_detail"))
      accessoryView?.tintColor = cellColor
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

extension DriveSyncFolderListTableViewController {
  class EmptyStateView: UIView {
    
    private lazy var label: UILabel = {
      let label = UILabel()
      label.font = ArduinoTypography.paragraphFont
      label.textColor = ArduinoColorPalette.grayPalette.tint400
      label.textAlignment = .center
      return label
    }()
    
    init(text: String) {
      super.init(frame: .zero)
      setupView()
      label.text = text
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
      label.translatesAutoresizingMaskIntoConstraints = false
      addSubview(label)
      NSLayoutConstraint.activate([
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        label.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
      
      sizeToFit()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
      var size = super.sizeThatFits(size)
      size.height = label.frame.height + 40
      return size
    }
  }

}
