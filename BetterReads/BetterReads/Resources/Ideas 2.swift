//
//  Helpers.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/22/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class Helpers {
}

// Animation
extension UIView {
  func performFlare() {
    func flare() { transform = CGAffineTransform( scaleX: 1.03, y: 1.04) }
    func unflare() { transform = .identity }
    UIView.animate(withDuration: 0.15,
                   animations: { flare() },
                   completion: { _ in UIView.animate(withDuration: 0.7) { unflare() }})
  }
}

extension UIColor {
    // Catalina Blue #071A81
    static let catalinaBlue = UIColor(red: 11.0/255.0, green: 28.0/255.0, blue: 124.0/255.0, alpha: 1.0)
    // Cinnabar Red #E33434
    static let cinnabarRed = UIColor(red: 208.0/255.0, green: 68.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    // Tundra #404040
    static let tundra = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    // Dove Gray #737373
    static let doveGray = UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    // Alto Gray #D9D9D9
    static let altoGray = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
}
