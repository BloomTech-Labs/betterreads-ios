//
//  Ideas.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/22/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

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

//let tundraColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0) // Tundra #404040
