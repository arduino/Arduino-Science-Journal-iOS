//  
//  SignUpJuniorAvatarView.swift
//  ScienceJournal
//
//  Created by Emilio Pavia on 08/04/21.
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
import PocketSVG

class SignUpJuniorAvatarView: UIView {
  
  var image: Data? {
    didSet {
      guard let data = image else {
        imageView = nil
        return
      }
      imageView = SVGImageView()
      imageView?.paths = SVGBezierPath.paths(fromSVGString: String(data: data, encoding: .utf8)!)
    }
  }

  private var imageView: SVGImageView? {
    didSet {
      oldValue?.removeFromSuperview()
      if let newValue = imageView {
        insertSubview(newValue, at: 0)
        newValue.translatesAutoresizingMaskIntoConstraints = false
        newValue.pinToEdgesOfView(self)
      }
    }
  }
  
  init() {
    super.init(frame: .zero)
    clipsToBounds = true
    
    let overlayView = UIView()
    overlayView.translatesAutoresizingMaskIntoConstraints = false
    overlayView.backgroundColor = ArduinoColorPalette.grayPalette.tint700
    
    let editImageView = UIImageView(image: UIImage(named: "sign_in_avatar_edit"))
    editImageView.translatesAutoresizingMaskIntoConstraints = false
    overlayView.addSubview(editImageView)
    
    addSubview(overlayView)
    
    NSLayoutConstraint.activate([
      overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
      overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
      overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
      overlayView.heightAnchor.constraint(equalToConstant: 30),
      editImageView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
      editImageView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = min(frame.size.width, frame.size.height) / 2.0
  }
}
