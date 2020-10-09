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

import MaterialComponents.MaterialTypography

/// A view composed of a sensor recording from a trial, which includes the title of the sensor,
/// min/average/max values across the recording, the icon for the sensor used, and a chart view
/// of the recorded data.
class TrialCardSensorView: ExperimentCardView {

  // MARK: - Properties

  /// The height of a trial card sensor view.
  static let height: CGFloat = {
    // Padding at the top of the view.
    var totalHeight = ExperimentCardView.innerVerticalPadding
    // Measure the title label's height and use it or the icon's height, whichever is bigger.
    let titleFont = ArduinoTypography.titleFont
    let titleHeight = ceil(String.decibel.labelHeight(withConstrainedWidth: 0, font: titleFont))
    totalHeight += max(titleHeight, Metrics.iconDimension)
    // SensorStatsView height.
    totalHeight += SensorStatsView.height
    // ChartView height.
    totalHeight += ChartPlacementType.previewReview.height
    // Padding between all the stacks and the padding at the bottom of the view.
    totalHeight += ExperimentCardView.innerVerticalPadding * 3

    return totalHeight
  }()

  /// The sensor to display.
  var displaySensor: DisplaySensor? {
    didSet {
      updateViewWithSensor()
    }
  }

  var experimentDisplay: ExperimentDisplay = .normal

  private let sensorIconView = UIView()
  private let titleLabel = UILabel()
  private let titleWrapper = UIView()
  private let sensorStatsView = SensorStatsView(min: "0", average: "0", max: "0")
  private var chartPresentationView: UIView?

  private enum Metrics {
    /// The height and width of icons used in this cell.
    static let iconDimension: CGFloat = 24.0
    
    // Spacing between the icon and title, horizontally.
    static let titleSpacing: CGFloat = 10.0
  }

  // MARK: - Public

  override required init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureView()
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: TrialCardSensorView.height)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    // The icon and title are centered in the view and looks like:
    // [icon] Title
    let titleWrapperHeight = max(Metrics.iconDimension, titleLabel.frame.height)
    let maxTitleLabelWidth = bounds.width - ExperimentCardView.horizontalPaddingTotal -
        Metrics.titleSpacing - Metrics.iconDimension
    sensorIconView.frame = CGRect(x: 0,
                              y: floor((titleWrapperHeight - Metrics.iconDimension) / 2),
                              width: Metrics.iconDimension * 2,
                              height: Metrics.iconDimension)
    titleLabel.sizeToFit()
    titleLabel.frame = CGRect(x: sensorIconView.frame.maxX + Metrics.titleSpacing,
                              y: floor((titleWrapperHeight - titleLabel.frame.height) / 2),
                              width: min(titleLabel.frame.width, maxTitleLabelWidth),
                              height: titleLabel.frame.height)
    let titleWrapperWidth = sensorIconView.frame.width + Metrics.titleSpacing + titleLabel.frame.width
    titleWrapper.frame = CGRect(x: floor((bounds.width - titleWrapperWidth) / 2),
                                y: ExperimentCardView.innerVerticalPadding,
                                width: titleWrapperWidth,
                                height: titleWrapperHeight)
    [sensorIconView, titleLabel].forEach { $0.adjustFrameForLayoutDirection() }

    // Stats view
    sensorStatsView.frame =
        CGRect(x: floor((bounds.width - sensorStatsView.frame.width) / 2),
               y: titleWrapper.frame.maxY + ExperimentCardView.innerVerticalPadding,
               width: sensorStatsView.frame.width,
               height: sensorStatsView.frame.height)

    // Chart presentation view
    chartPresentationView?.frame =
        CGRect(x: 0,
               y: sensorStatsView.frame.maxY + ExperimentCardView.innerVerticalPadding,
               width: bounds.width,
               height: experimentDisplay.trialCardSensorViewHeight)
  }

  // MARK: - Private

  private func configureView() {
    // Icon
    titleWrapper.addSubview(sensorIconView)

    // Title
    titleLabel.textColor = ArduinoColorPalette.grayPalette.tint800
    titleLabel.font = ArduinoTypography.titleFont
    titleWrapper.addSubview(titleLabel)
    addSubview(titleWrapper)

    // Accessibility
    configureAccessibility(titleText: titleLabel.text)

    // Stats view
    addSubview(sensorStatsView)
  }

  private func configureAccessibility(titleText: String?) {
    titleWrapper.isAccessibilityElement = true
    titleWrapper.accessibilityTraits = .staticText
    titleWrapper.accessibilityLabel = titleText
  }

  private func updateViewWithSensor() {
    guard let displaySensor = displaySensor else { return }

    //TODO Extract into classes and reuse image views
    sensorIconView.subviews.forEach({ $0.removeFromSuperview() })
    
    // Icon
    let sensorIconImage = UIImageView()
    sensorIconImage.tintColor = displaySensor.colorPalette?.tint600
    sensorIconImage.image = displaySensor.icon
    sensorIconImage.sizeToFit()
        
    let isExternalSensor = (displaySensor.ID.prefix(4) == "555A" ||  displaySensor.ID.contains("bluetooth"))
    let type = isExternalSensor ? "sensor_type_arduino" : "sensor_type_phone"
    let sensorTypeImage = UIImageView(image: UIImage(named: type))
    sensorIconImage.sizeToFit()
    
    sensorIconView.addSubview(sensorTypeImage)
    sensorIconView.addSubview(sensorIconImage)
    sensorIconImage.frame.origin = CGPoint(x: Metrics.iconDimension, y: 0)

    // Title
    titleLabel.text = displaySensor.title

    // Accessibility text update
    configureAccessibility(titleText: displaySensor.title)

    // Stats view
    sensorStatsView.textColor = displaySensor.colorPalette?.tint600
    sensorStatsView.setMin(displaySensor.minValueString,
                           average: displaySensor.averageValueString,
                           max: displaySensor.maxValueString)
    sensorStatsView.sizeToFit()

    // Chart presentation view. If the chart presentation view doesn't exist, this is an error
    // state. Default to a blank view to fail gracefully.
    chartPresentationView?.removeFromSuperview()
    let chart = displaySensor.chartPresentationView ?? UIView()
    addSubview(chart)
    chartPresentationView = chart

    setNeedsLayout()
  }

}
