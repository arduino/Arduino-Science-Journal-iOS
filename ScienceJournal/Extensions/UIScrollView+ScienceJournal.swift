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

extension UIScrollView {

  /// Scrolls to the top by setting the content offset to zero.
  func scrollToTop() {
    contentOffset = .zero
  }

  /// If the content of the scroll view is outside of or intersecting with the safe area.
  var isContentOutsideOfSafeArea: Bool {
    let contentOnscreenHeight = contentSize.height - contentOffset.y
    let contentOffscreenHeight = contentOnscreenHeight - bounds.height
    let safeAreaHeight = adjustedContentInset.bottom - contentInset.bottom
    let distanceAboveSafeArea = (contentOffscreenHeight + safeAreaHeight) * -1
    let isItSafe = distanceAboveSafeArea <= -1
    return isItSafe
  }

}
