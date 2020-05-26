//
//  LaunchViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/26/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseIn, animations: {
            self.logoImageView.alpha = 0.0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.performSegue(withIdentifier: "ShowSignUpScreen", sender: nil)
        })
    }
}
