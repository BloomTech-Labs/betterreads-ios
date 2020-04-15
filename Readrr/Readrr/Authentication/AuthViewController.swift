//
//  AuthViewController.swift
//  Readrr
//
//  Created by Alexander Supe on 4/14/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: IBOutlets
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
    
    // MARK: Properties
    var isLogin = true
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: IBActions
    @IBAction func signupTapped(_ sender: Any) {
        signup()
    }
    @IBAction func switchModeTapped(_ sender: Any) {
        switchMode()
    }
    @IBAction func resetPasswordTapped(_ sender: Any) {
        resetPassword()
    }
    
    // MARK: Helpers
    private func signup() {
        var fields: [UITextField: UILabel] = [emailField: emailLabel, passwordField: passwordLabel]
        if !isLogin { fields[nameField] = nameLabel }
        guard let email = emailField.text, let password = passwordField.text, checkFields(fields: fields) else { return }
        AuthenticationController.signUp(with: isLogin ? nil : nameField.text, email: email, password: password) { result in
            // FIXME: Wait for status codes - implement error handling
        }
    }
    
    private func switchMode() {
        isLogin.toggle()
        fullnameStack.isHidden = isLogin ? true : false
        signupButton.setTitle(isLogin ? "Sign In" : "Sign Up", for: .normal)
        modeLabel.text = isLogin ? " New?" : " Already Back?"
        modeButton.setTitle(isLogin ? "Sign Up" : "Sign In", for: .normal)
        passwordField.textContentType = isLogin ? .password : .newPassword
    }
    
    private func resetPassword() {
        // FIXME: Wait for backend
    }
    
    private func checkFields(fields: [UITextField: UILabel]) -> Bool {
        for label in fields.values {
            label.textColor = .darkGray
        }
        var isEmpty = true
        for field in fields {
            if field.key.text?.isEmpty ?? true {
                field.value.textColor = .red
                isEmpty = false
            }
        }
        return isEmpty
    }
}

