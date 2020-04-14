//
//  AuthViewController.swift
//  Readrr
//
//  Created by Alexander Supe on 4/14/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var fullnameStack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: ModernTextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameField: ModernTextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: ModernTextField!
    @IBOutlet weak var signupButton: ModernButton!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var modeButton: ModernButton!
    
    private var mode: AuthMode = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signupTapped(_ sender: Any) {
        if mode == .login { signin() }
        else { signup() }
    }
    @IBAction func switchModeTapped(_ sender: Any) {
        switchMode()
    }
    @IBAction func resetPasswordTapped(_ sender: Any) {
        resetPassword()
    }
    
    private func signup() {
        
    }
    
    private func signin() {
        
    }
    
    private func switchMode() {
        if mode == .login {
            mode = .register
            fullnameStack.isHidden = false
            signupButton.setTitle("Sign Up", for: .normal)
            modeLabel.text = " Already Back?"
            modeButton.setTitle("Sign In", for: .normal)
        } else {
            mode = .login
            fullnameStack.isHidden = true
            signupButton.setTitle("Sign In", for: .normal)
            modeLabel.text = " New?"
            modeButton.setTitle("Sign Up", for: .normal)
            }
    }
    
    private func resetPassword() {
        // FIXME: Wait for backend
    }
    
    enum AuthMode {
        case login
        case register
    }
}

