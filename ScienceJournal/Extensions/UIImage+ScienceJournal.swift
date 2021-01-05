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

extension UIImage {

  /// Modes for rendering an image into a rect.
  enum ImageRenderMode {
    case fill
    case fit
  }

  /// Returns copy of self sized as requested.
  func sized(to size: CGSize) -> UIImage {
    let rect = CGRect(origin: .zero, size: size)
    let renderer = UIGraphicsImageRenderer(size: size)
    let image = renderer.image { _ in
      draw(in: rect)
    }
    return image
  }

  /// Returns copy of self, centered to the requested size with specified render mode.
  ///
  /// - Parameters:
  ///   - to size: The requested size.
  ///   - renderMode: The render mode.
  /// - Returns: Self resized with params.
  func sizedWithAspect(to size: CGSize, renderMode: ImageRenderMode = .fill) -> UIImage {
    let widthRatio = size.width / self.size.width
    let heightRatio = size.height / self.size.height
    let aspectRatio: CGFloat = {
      switch renderMode {
      case .fill:
        return max(widthRatio, heightRatio)
      case .fit:
        return min(widthRatio, heightRatio)
      }
    }()

    var scaledRect = CGRect.zero
    scaledRect.size = CGSize(width: self.size.width * aspectRatio,
                             height: self.size.height * aspectRatio)
    scaledRect.origin = CGPoint(x: floor((size.width - scaledRect.size.width) / 2.0),
                                y: floor((size.height - scaledRect.size.height) / 2.0))
    let renderer = UIGraphicsImageRenderer(size: size)
    let image = renderer.image { _ in
      draw(in: scaledRect)
    }
    return image
  }

  class func stroke(color: UIColor,
                    size: CGSize = CGSize(width: 1, height: 1),
                    lineWidth: CGFloat = 1,
                    cornerRadius: CGFloat = 0) -> UIImage? {

    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }

    color.setStroke()
    context.setLineWidth(lineWidth)

    let rect = CGRect(x: 0,
                      y: 0,
                      width: size.width,
                      height: size.height).insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
    let path = UIBezierPath(roundedRect: rect,
                            cornerRadius: cornerRadius)

    path.stroke()

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }

  class func fill(color: UIColor,
                  size: CGSize = CGSize(width: 1, height: 1),
                  cornerRadius: CGFloat = 0) -> UIImage? {

    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()

    let rect = CGRect(x: 0,
                      y: 0,
                      width: size.width,
                      height: size.height)
    let path = UIBezierPath(roundedRect: rect,
                            cornerRadius: cornerRadius)
    path.fill()

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
  }
}
