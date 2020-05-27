//
//  AnimationViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/13/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {
    @IBOutlet weak var blobBackgroundImage: UIImageView!
    @IBOutlet weak var circleBookImage: UIImageView!
    @IBOutlet weak var dashedCircleImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 5.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.dashedCircleImage.transform = CGAffineTransform(rotationAngle: 360.0)
        })
        UIView.animate(withDuration: 2.0, delay: 2.5, options: .curveEaseIn, animations: {
            self.blobBackgroundImage.alpha = 0.0
            self.circleBookImage.alpha = 0.0
            self.dashedCircleImage.alpha = 0.0
        })
    }
}
