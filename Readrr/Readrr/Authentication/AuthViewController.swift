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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: ModernTextField!
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
        // FIXME: Check for empty/invalid fields
        guard let name = nameField.text, let email = emailField.text, let password = passwordField.text else { return }
        AuthenticationController.signUp(with: name, email: email, password: password) { (response) in
            
        }
    }
    
    private func signin() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        AuthenticationController.signIn(with: email, password: password) { (response) in
            
        }
    }
    
    private func switchMode() {
        if mode == .login {
            mode = .register
            fullnameStack.isHidden = false
            signupButton.setTitle("Sign Up", for: .normal)
            modeLabel.text = " Already Back?"
            modeButton.setTitle("Sign In", for: .normal)
            passwordField.textContentType = .newPassword
        } else {
            mode = .login
            fullnameStack.isHidden = true
            signupButton.setTitle("Sign In", for: .normal)
            modeLabel.text = " New?"
            modeButton.setTitle("Sign Up", for: .normal)
            passwordField.textContentType = .password
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

