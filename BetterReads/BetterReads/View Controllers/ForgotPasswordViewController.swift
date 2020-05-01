//
//  ForgotPasswordViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/30/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    var userController = UserController()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var successOrFailureMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        clearMessages()
        successOrFailureMessage.isHidden = true
        doneButton.layer.cornerRadius = 5
        
        // Dismiss the keyboard on tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Register View Controller as Observer
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        var formIsValid = true
        doneButton.backgroundColor = .catalinaBlue
        
        let textFields: [UITextField] = [emailTextField]

        for textField in textFields {
            // Validate Text Field
            let (valid, _) = validate(textField)
            guard valid else {
                formIsValid = false
                break
            }
        }
        
        doneButton.backgroundColor = formIsValid ? .catalinaBlue : .tundra
        doneButton.isEnabled = formIsValid
    }
    
    private func clearMessages() {
        successOrFailureMessage.text = " "
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        let (valid, _) = validate()
        if valid {
            sendEmailToUser()
        }
    }
    
    private func validate(_ field: UITextField? = nil) -> (Bool, String?) {
        do {
            switch field {
            case emailTextField:
                let _ = try emailTextField.validatedText(validationType: .email(field: "email"))
                return (true, nil)
            default:
                let _ = try emailTextField.validatedText(validationType: .email(field: "email"))
                return (true, nil)
            }
        } catch(let error) {
            let convertedError = (error as! ValidationError)
            return (false, convertedError.message)
        }
    }
    
    private func sendEmailToUser() {
        guard let emailAddress = emailTextField.text else { return }
        
        userController.forgotPasswordEmail(emailAddress: emailAddress) { (networkError) in
            if let error = networkError {
                self.presentForgotPasswordErrorAlert()
                NSLog("Error occured during Forgot Password: \(error)")
            } else {
                print("Forgot password reset in progress...")
            }
        }
    }
    
    private func presentForgotPasswordErrorAlert() {
        let alert = UIAlertController(title: "Forgot Password Error", message: "An error occured while submitting your request,\nplease try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let (valid, message) = validate(textField)
        
        if valid {
            emailTextField.resignFirstResponder()
        }
        
        self.successOrFailureMessage.text = message
        if (valid) {
            self.successOrFailureMessage.text = " "
        }
        return true
    }
}
