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

/// Pull to refresh controllers.
public class PullToRefreshController {

  private let actionBlock: () -> Void

  private let scrollView: UIScrollView
  private let refreshControl: UIRefreshControl
  
  /// Initializes the pull to refresh controller for a scroll view with an action block.
  ///
  /// - Parameters:
  ///   - scrollView: The scroll view.
  ///   - actionBlock: The action block.
  init(scrollView: UIScrollView, actionBlock: @escaping () -> Void) {
    self.actionBlock = actionBlock
    self.scrollView = scrollView
    self.refreshControl = UIRefreshControl()
    
    refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    scrollView.refreshControl = refreshControl
  }

  /// Starts the refresh animation.
  func startRefreshing() {
    if !refreshControl.isRefreshing {
      refreshControl.beginRefreshing()
    }
  }

  /// Ends the refresh animation.
  func endRefreshing() {
    if refreshControl.isRefreshing {
      refreshControl.endRefreshing()
    }
  }

  @objc private func handleRefreshControl() {
    actionBlock()
  }
}
