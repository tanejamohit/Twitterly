//
//  ImageExtensions.swift
//  Twitterly
//
//  Created by Mohit Taneja on 10/8/17.
//  Copyright © 2017 Mohit Taneja. All rights reserved.
//

import UIKit

class ImageExtensions: NSObject {

}

extension UIImageView {
  func setRadius(radius: CGFloat? = nil) {
    self.layer.cornerRadius = radius ?? self.frame.width / 2;
    self.layer.masksToBounds = true;
  }
}

