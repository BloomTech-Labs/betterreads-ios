//
//  ForgotPasswordViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/30/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorMessage: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var doneActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var successOrFailureMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailErrorMessage.text = " "
        successOrFailureMessage.text = " "
        doneButton.layer.cornerRadius = 5
        doneActivityIndicator.layer.cornerRadius = 5
        doneButton.isEnabled = false
        doneActivityIndicator.isHidden = true
        // Dismiss the keyboard on tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        // Register View Controller as Observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }
    @objc private func textDidChange(_ notification: Notification) {
        doneButton.backgroundColor = .trinidadOrange
        let (valid, _) = validate(emailTextField)
        guard valid else {
            doneButton.backgroundColor = .altoGray
            doneButton.isEnabled = false
            return
        }
        emailErrorMessage.text = " "
        doneButton.backgroundColor = .trinidadOrange
        doneButton.isEnabled = true
    }
    @IBAction func downArrowButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        doneActivityIndicator.isHidden = false
        doneActivityIndicator.startAnimating()
        let (valid, _) = validate()
        if valid {
            guard let emailAddress = emailTextField.text else { return }
            UserController.shared.forgotPasswordEmail(emailAddress: emailAddress) { (networkError) in
                if let error = networkError {
                    self.showBasicAlert(alertText: "Forgot Password Error",
                                        alertMessage: "An error occurred when processing your request.",
                                        actionTitle: "Try again")
                    NSLog("Error occured during Forgot Password: \(error)")
                    self.doneActivityIndicator.stopAnimating()
                    self.doneActivityIndicator.isHidden = true
                } else {
                    print("Forgot password reset in progress...")
                    self.doneActivityIndicator.stopAnimating()
                    self.doneActivityIndicator.isHidden = true
                    self.doneButton.isEnabled = false
                    self.doneButton.backgroundColor = .altoGray
                    self.successOrFailureMessage.text = "Thank you! A reset password email has been sent."
                }
            }
        }
    }
    private func validate(_ field: UITextField? = nil) -> (Bool, String?) {
        do {
            _ = try emailTextField.validatedText(validationType: .email(field: "email"))
            return (true, nil)
        } catch let error {
            let convertedError = (error as? ValidationError)
            return (false, convertedError?.message)
        }
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let (valid, message) = validate()
        if valid {
            self.emailErrorMessage.text = " "
            emailTextField.resignFirstResponder()
            doneButtonTapped(doneButton)
            return true
        }
        self.emailErrorMessage.text = message
        return true
    }
}
