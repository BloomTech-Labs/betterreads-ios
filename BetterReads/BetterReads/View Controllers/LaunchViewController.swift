//
//  LaunchViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/13/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet weak var blobBackgroundImage: UIImageView!
    @IBOutlet weak var circleBookImage: UIImageView!
    @IBOutlet weak var dashedCircleImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, delay: 0.3, options: .curveEaseIn, animations: {
            self.blobBackgroundImage.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            self.dashedCircleImage.transform = CGAffineTransform(rotationAngle: -20.0)
        })
        UIView.animate(withDuration: 1.5, delay: 0.3, options: .curveEaseIn, animations: {
            self.blobBackgroundImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.dashedCircleImage.transform = CGAffineTransform(rotationAngle: -20.0)
        })
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseIn, animations: {
            self.blobBackgroundImage.alpha = 0.0
            self.circleBookImage.alpha = 0.0
            self.dashedCircleImage.alpha = 0.0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25, execute: {
            self.performSegue(withIdentifier: "ShowMainScreen", sender: nil)
        })
    }
}
