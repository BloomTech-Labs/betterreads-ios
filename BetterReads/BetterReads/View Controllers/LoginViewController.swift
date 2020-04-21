//
//  LoginViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez & Ciara "CC" Beitel on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    enum LoginType {
        case signup
        case signin
    }
    
    var loginType = LoginType.signup
    var userController = UserController()
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
    }
        
    // MARK: - Methods
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        print("segmented control value changed")
        if sender.selectedSegmentIndex == 0 {
            loginType = .signup
            submitButton.setTitle("Sign Up", for: .normal)
            fullNameTextField.isHidden = false
            fullNameLabel.isHidden = false
        } else {
            loginType = .signin
            submitButton.setTitle("Sign In", for: .normal)
            fullNameTextField.isHidden = true
            fullNameLabel.isHidden = true
        }
        submitButton.performFlare()
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        print("signUpTapped")
        guard let fullname = fullNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !fullname.isEmpty,
            !email.isEmpty,
            !password.isEmpty else { return }
        let user = User(fullName: fullname, email: email, password: password)
        if loginType == .signup {
            userController.signUp(user: user) { (networkError) in
                if let error = networkError {
                    NSLog("Error occured during Sign Up: \(error)")
                } else {
                    let alert = UIAlertController(title: "Sign Up Successful", message: "Please Sign In", preferredStyle: .alert)
                    let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: nil)
                    alert.addAction(signInAction)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: {
                            self.loginType = .signin
                            self.segmentedControl.selectedSegmentIndex = 1
                            self.submitButton.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            }
        } else if loginType == .signin {
            // FIXME: - remove full name text field (hide)
            
            userController.signIn(email: email, password: password) { (networkError) in
                if let error = networkError {
                    NSLog("Error occured during Sign In: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.seg()
                    }
                }
            }
        }
    }

    // MARK: - Navigation
    func seg() {
        print("Called seg()")
        performSegue(withIdentifier: "SignInSuccessSegue", sender: self)
    }
}

// Animation
extension UIView {
  func performFlare() {
    func flare() { transform = CGAffineTransform( scaleX: 1.1, y: 1.1) }
    func unflare() { transform = .identity }
    UIView.animate(withDuration: 0.3,
                   animations: { flare() },
                   completion: { _ in UIView.animate(withDuration: 0.2) { unflare() }})
  }
}
