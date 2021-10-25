//
//  WizardNavigationController.swift
//  ScienceJournalg
//
//  Created by Emilio Pavia on 04/01/21.
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

class WizardNavigationController: UINavigationController {

    override func viewDidLoad() {
      super.viewDidLoad()

      navigationBar.barTintColor = ArduinoColorPalette.grayPalette.tint100

      if #available(iOS 13.0, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ArduinoColorPalette.grayPalette.tint100

        appearance.titleTextAttributes = [
          NSAttributedString.Key.font: ArduinoTypography.boldFont(forSize: 20),
          NSAttributedString.Key.foregroundColor: ArduinoColorPalette.tealPalette.tint800!
        ]

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
      }

      navigationBar.isTranslucent = false
      navigationBar.shadowImage = UIImage()

      let backImage = UIImage(named: "arduino_navigation_back")
      navigationBar.backIndicatorImage = backImage
      navigationBar.backIndicatorTransitionMaskImage = backImage
    }

}
