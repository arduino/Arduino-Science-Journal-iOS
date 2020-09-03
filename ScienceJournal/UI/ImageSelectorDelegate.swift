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

typealias ImageData = (imageData: Data, metadata: NSDictionary?)

/// Delegate protocol for the camera and photo library to communicate when an image has been created
/// or picked for a note.
protocol ImageSelectorDelegate: class {

  /// Tells the delegate that one or more image datas have been created, each with an optional
  /// metadata.
  func imageSelectorDidCreateImageData(_ imageDatas: [ImageData])

  /// Tells the delegate image selection was cancelled.
  func imageSelectorDidCancel()

}
