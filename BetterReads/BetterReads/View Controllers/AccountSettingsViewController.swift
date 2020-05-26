//
//  AccountSettingsViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/12/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    @IBAction func downArrowButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell")
            as? SettingsTableViewCell ?? SettingsTableViewCell()
        if indexPath.row == 0 {
            cell.settingsTitleLabel.text = "Password"
            cell.settingIconImageView.image = UIImage(systemName: "lock.circle.fill")
        } else if indexPath.row == 1 {
            cell.settingsTitleLabel.text = "About"
            cell.settingIconImageView.image = UIImage(systemName: "info.circle.fill")
        } else {
            cell.settingsTitleLabel.text = "Logout"
            cell.settingIconImageView.image = UIImage(systemName: "arrow.uturn.left.circle.fill")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            // This is the dirty way, consider a better alternative to logging out
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
