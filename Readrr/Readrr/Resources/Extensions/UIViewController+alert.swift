//
//  UIViewController+alert.swift
//  Readrr
//
//  Created by Alexander Supe on 4/15/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlert(with title: String, message: String? = nil, options: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in options {
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
}
