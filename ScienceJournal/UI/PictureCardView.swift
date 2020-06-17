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

import third_party_objective_c_material_components_ios_components_Palettes_Palettes

/// PictureCardView supports two different heights, depending on usage. In a Trial card, as a Trial
/// Note, it uses `.small`. In a standalone picture cell, it uses `.large`.
enum PictureStyle {
  case small
  case large

  var height: CGFloat {
    switch self {
    case .small: return 100.0
    case .large: return 300.0
    }
  }
}

/// A view composed of a picture. This view can be used inside a trial card or inside a snapshot
/// card, both in Experiment detail views. Timestamp can be shown by setting `showRelativeTimestamp`
/// to true.
class PictureCardView: ExperimentCardView {

  // MARK: - Properties

  /// The image to display. If the style is large and this image is set to nil, a placeholder image
  /// will be shown.
  var image: UIImage? {
    didSet {
      guard let image = image else {
        switch style {
        case .large:
          imageView.contentMode = .center
          imageView.image = UIImage(named: "photo_placeholder")
        case .small:
          imageView.image = nil
        }
        return
      }

      imageView.contentMode = experimentDisplay.pictureContentMode
      imageView.backgroundColor = experimentDisplay.pictureBackgroundColor
      imageView.image = image
      experimentDisplay.updateTimestamp(label: timestampLabel)
    }
  }

  /// The optional image path for the picture note's image.
  private(set) var pictureNoteImagePath: String?

  /// The picture note to display.
  var pictureNote: DisplayPictureNote? {
    didSet {
      updateForPictureNote()
    }
  }

  /// Whether or not to show the timestamp.
  var showTimestamp: Bool {
    didSet {
      updateTimestampHidden()
    }
  }

  var experimentDisplay: ExperimentDisplay = .normal

  /// The picture style.
  let style: PictureStyle

  private let imageView = UIImageView()

  // MARK: - Public

  init(pictureNote: DisplayPictureNote? = nil, style: PictureStyle, showTimestamp: Bool = false) {
    self.pictureNote = pictureNote
    self.style = style
    self.showTimestamp = showTimestamp
    super.init(frame: .zero)
    updateForPictureNote()
    configureView()
  }

  override required init(frame: CGRect) {
    fatalError("init(frame:) is not supported")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: style.height)
  }

  override func reset() {
    pictureNote = nil
    pictureNoteImagePath = nil
    timestampLabel.text = nil
  }

  // MARK: - Private

  private func configureView() {
    // Image view, which fills the full width and height of this view, and clips to bounds.
    addSubview(imageView)
    imageView.backgroundColor = experimentDisplay.pictureBackgroundColor
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 11.0, *) {
      imageView.accessibilityIgnoresInvertColors = true
    }
    imageView.pinToEdgesOfView(self)

    // Timestamp label. Update styling based on the current experiment display.
    experimentDisplay.updateTimestamp(label: timestampLabel)
    addSubview(timestampLabel)
    timestampLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    timestampLabel.topAnchor.constraint(
        equalTo: topAnchor,
        constant: ExperimentCardView.innerVerticalPadding).isActive = true
    timestampLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -ExperimentCardView.innerHorizontalPadding).isActive = true
    updateTimestampHidden()
  }

  private func updateForPictureNote() {
    pictureNoteImagePath = pictureNote?.imagePath
    timestampLabel.text = pictureNote?.timestamp.string
  }

  private func updateTimestampHidden() {
    timestampLabel.isHidden = !showTimestamp
  }

}
