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
        var actions = options
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.append(UIAlertAction(title: "Done", style: .default, handler: nil))
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
}
