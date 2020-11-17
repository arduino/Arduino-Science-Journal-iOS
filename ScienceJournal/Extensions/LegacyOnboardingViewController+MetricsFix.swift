//
//  LegacyOnboardingViewController+MetricsFix.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 17/06/2020.
//  Copyright © 2020 Arduino. All rights reserved.
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

/*
 This file fixes a build error arised after a Swift bugfix:
 https://bugs.swift.org/browse/SR-3492
 
 We might refactor the entire app architecture in the future, so for now
 let's add this quick workaround without touching any existing source code.
 */

extension PermissionsGuideViewController.Metrics {
  static var bodyFont: UIFont { LegacyOnboardingViewController.Metrics.bodyFont }
  static var buttonSpacing: CGFloat { LegacyOnboardingViewController.Metrics.buttonSpacing }
  static var innerSpacing: CGFloat { LegacyOnboardingViewController.Metrics.innerSpacing }
  static var outerPaddingNarrow: CGFloat { LegacyOnboardingViewController.Metrics.outerPaddingNarrow }
  static var outerPaddingWide: CGFloat { LegacyOnboardingViewController.Metrics.outerPaddingWide }
}

extension SignInViewController.Metrics {
  static var backgroundColor: UIColor { LegacyOnboardingViewController.Metrics.backgroundColor }
  static var bodyFont: UIFont { LegacyOnboardingViewController.Metrics.bodyFont }
  static var buttonSpacing: CGFloat { LegacyOnboardingViewController.Metrics.buttonSpacing }
  static var buttonSpacingInner: CGFloat { LegacyOnboardingViewController.Metrics.buttonSpacingInner }
  static var buttonSpacingWide: CGFloat { LegacyOnboardingViewController.Metrics.buttonSpacingWide }
  static var outerPaddingNarrow: CGFloat { LegacyOnboardingViewController.Metrics.outerPaddingNarrow }
  static var outerPaddingWide: CGFloat { LegacyOnboardingViewController.Metrics.outerPaddingWide }
}

extension WelcomeViewController.Metrics {
  static var bodyFont: UIFont { LegacyOnboardingViewController.Metrics.bodyFont }
  static var buttonSpacing: CGFloat { LegacyOnboardingViewController.Metrics.buttonSpacing }
  static var innerSpacing: CGFloat { LegacyOnboardingViewController.Metrics.innerSpacing }
  static var outerPaddingNarrow: CGFloat { LegacyOnboardingViewController.Metrics.outerPaddingNarrow }
  static var outerPaddingWide: CGFloat { LegacyOnboardingViewController.Metrics.outerPaddingWide }
}
