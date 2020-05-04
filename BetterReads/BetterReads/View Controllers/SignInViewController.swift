//
//  SignInViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez & Ciara "CC" Beitel on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

enum LoginType {
    case signup
    case signin
}

class SignInViewController: UIViewController {

    // MARK: - Properties
    var loginType = LoginType.signup
    var userController = UserController()
    let segControlBackgroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
    let segControlDividerImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
    let regularFont = UIFont(name: "SourceSansPro-Regular", size: 16)
    let semiBoldFont = UIFont(name: "SourceSansPro-SemiBold", size: 20)
    let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tundra, NSAttributedString.Key.font : UIFont(name: "SourceSansPro-SemiBold", size: 20)]
    let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tundra, NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 16)]
    var passwordEyeballButton = UIButton()
    var confirmPasswordEyeballButton = UIButton()
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var fullNameErrorMessage: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorMessage: UILabel!
    @IBOutlet weak var passwordInfoCircle: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorMessage: UILabel!
    @IBOutlet weak var confirmPasswordInfoCircle: UIButton!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorMessage: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var directToSearch: UIButton!
    
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        clearErrorMessages()
        setupCustomSegmentedControl()
        configurePasswordTextField()
        configureConfirmTextField()
        forgotPassword.isHidden = true
        submitButton.layer.cornerRadius = 5
        
        // Dismiss the keyboard on tap
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Register View Controller as Observer
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        var formIsValid = true
        submitButton.backgroundColor = .trinidadOrange
        
        let textFields: [UITextField] = [fullNameTextField, emailTextField, passwordTextField, confirmPasswordTextField]

        for textField in textFields {
            // Validate Text Field
            let (valid, _) = validate(textField)
            guard valid else {
                formIsValid = false
                break
            }
        }
        // Update Save Button
        submitButton.backgroundColor = formIsValid ? .trinidadOrange : .tundra
        submitButton.isEnabled = formIsValid
    }
    
    // MARK: - Methods
    private func clearErrorMessages() {
        fullNameErrorMessage.text = " "
        emailErrorMessage.text = " "
        passwordErrorMessage.text = " "
        confirmPasswordErrorMessage.text = " "
    }
    
    // MARK: - Custom Segmented Control
    private func setupCustomSegmentedControl() {
        // Change font on the segmented control, add a default font to dismiss warning
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : semiBoldFont ?? UIFont()], for: .selected)
        // Change the background and divider image on the segmented control to a transparent (clear) image in the extension at the bottom of this file
        segmentedControl.setBackgroundImage(segControlBackgroundImage, for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(segControlDividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        // Change the text color on the segmented control for selected and normal states
        segmentedControl.setTitleTextAttributes(selectedTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        segmentedControl.setTitleTextAttributes(normalTextAttributes as [NSAttributedString.Key : Any], for: .normal)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            setUpSignUpForm()
        } else {
            setUpSignInForm()
        }
    }
    
    private func setUpSignUpForm() {
        loginType = .signup
        submitButton.setTitle("Sign Up", for: .normal)
        fullNameLabel.isHidden = false
        fullNameTextField.isHidden = false
        confirmPasswordLabel.isHidden = false
        confirmPasswordTextField.isHidden = false
        segmentedControl.setTitleTextAttributes(selectedTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        clearErrorMessages()
        segmentedControl.selectedSegmentIndex = 0
        forgotPassword.isHidden = true
        passwordInfoCircle.isHidden = false
        confirmPasswordInfoCircle.isHidden = false
    }
    
    private func setUpSignInForm() {
        loginType = .signin
        submitButton.setTitle("Sign In", for: .normal)
        fullNameLabel.isHidden = true
        fullNameTextField.isHidden = true
        confirmPasswordLabel.isHidden = true
        confirmPasswordTextField.isHidden = true
        segmentedControl.setTitleTextAttributes(normalTextAttributes as [NSAttributedString.Key : Any], for: .normal)
        clearErrorMessages()
        segmentedControl.selectedSegmentIndex = 1
        forgotPassword.isHidden = false
        passwordInfoCircle.isHidden = true
        confirmPasswordInfoCircle.isHidden = true
        passwordTextField.returnKeyType = .done
        passwordTextField.textContentType = .password
        emailTextField.textContentType = .emailAddress
    }

    // MARK: - Configure Text Fields for show/hide Password
    // FIXME: text should always be secured when clicking outside of textfield (on tap gesture)
    private func configurePasswordTextField() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = passwordEyeballButton
        passwordTextField.rightViewMode = .always
        passwordEyeballButton.tintColor = .doveGray
        passwordEyeballButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        passwordEyeballButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20.0, bottom: 0, right: 5.0)
        passwordEyeballButton.addTarget(self, action: #selector(tappedPasswordEyeballButton), for: .touchUpInside)
        passwordEyeballButton.isHidden = true
    }
    
    private func configureConfirmTextField() {
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.rightView = confirmPasswordEyeballButton
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordEyeballButton.tintColor = .doveGray
        confirmPasswordEyeballButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        confirmPasswordEyeballButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20.0, bottom: 0, right: 5.0)
        confirmPasswordEyeballButton.addTarget(self, action: #selector(tappedConfirmPasswordEyeballButton), for: .touchUpInside)
        confirmPasswordEyeballButton.isHidden = true
    }
        
    @objc private func tappedPasswordEyeballButton(field: UITextField) {
        if passwordTextField.isSecureTextEntry == true {
            // Show
            passwordEyeballButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        }
        else {
            // Hide
            passwordEyeballButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @objc private func tappedConfirmPasswordEyeballButton() {
        if confirmPasswordTextField.isSecureTextEntry == true {
            // Show
            confirmPasswordEyeballButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            confirmPasswordTextField.isSecureTextEntry = false
        }
        else {
            // Hide
            confirmPasswordEyeballButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            confirmPasswordTextField.isSecureTextEntry = true
        }
    }
    
    // MARK: - Validate text in Text Fields
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        let (valid, _) = validate()
        if valid {
            if loginType == .signup {
                signUpUser()
            } else {
                signInUser()
            }
        }
    }
        
    private func validate(_ field: UITextField? = nil) -> (Bool, String?) {
        do {
            switch field {
            case fullNameTextField:
                // if signIn, don't validate fullName textfield
                if segmentedControl.selectedSegmentIndex == 1 {
                    return (true, nil)
                }
                let _ = try fullNameTextField.validatedText(validationType: .required(field: "fullName"))
                return (true, nil)
            case emailTextField:
                let _ = try emailTextField.validatedText(validationType: .email(field: "email"))
                return (true, nil)
            case passwordTextField:
                let _ = try passwordTextField.validatedText(validationType: .password(field: "password"))
                return (true, nil)
            case confirmPasswordTextField:
                // if signIn, don't validate confirmPassword textfield
                if segmentedControl.selectedSegmentIndex == 1 {
                    return (true, nil)
                }
                let confirmPassword = try confirmPasswordTextField.validatedText(validationType: .password(field: "confirmPassword"))
                guard let password = passwordTextField.text else { return (false, "Passwords do not match.")}
                if confirmPassword != password {
                    print("\(password) \n \(confirmPassword)")
                    return (false, "Passwords do not match.")
                }
                return (true, nil)
            default:
                // default: validate all textfields one last time and call completion
                // unless you're on sign in, then don't validate fullName textfield
                if segmentedControl.selectedSegmentIndex == 0 {
                    let _ = try fullNameTextField.validatedText(validationType: .required(field: "fullName"))
                }
                let _ = try emailTextField.validatedText(validationType: .email(field: "email"))
                let password = try passwordTextField.validatedText(validationType: .password(field: "password"))
                // unless you're on sign in, then don't validate confirmPassword textfield
                if segmentedControl.selectedSegmentIndex == 0 {
                    let confirmPassword = try confirmPasswordTextField.validatedText(validationType: .password(field: "confirmPassword"))
                    
                    if confirmPassword != password {
                        print("\(password) \n \(confirmPassword)")
                        return (false, "Passwords do not match.")
                    }
                }
                return (true, nil)
            }
        } catch(let error) {
            let convertedError = (error as! ValidationError)
            return (false, convertedError.message)
        }
    }
    
    private func signUpUser() {
        guard let fullName = fullNameTextField.text,
            let emailAddress = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        userController.signUp(fullName: fullName, emailAddress: emailAddress, password: password) { (networkError) in
            if let error = networkError {
                self.presentSignUpErrorAlert()
                NSLog("Error occured during Sign Up: \(error)")
            } else {
                print("Sign up successful...now signing in...")
                self.userController.signIn(emailAddress: emailAddress, password: password) { (networkError) in
                    if let error = networkError {
                        self.setUpSignInForm()
                        self.presentSignInErrorAlert()
                        NSLog("Error occured during Sign In: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "SignInSuccessSegue", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    private func signInUser() {
        guard let emailAddress = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        userController.signIn(emailAddress: emailAddress, password: password) { (networkError) in
            if let error = networkError {
                self.presentSignInErrorAlert()
                NSLog("Error occured during Sign In: \(error)")
            } else {
                print("Sign in successful...")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SignInSuccessSegue", sender: self)
                }
            }
        }
    }
    
    private func presentSignUpErrorAlert() {
        let alert = UIAlertController(title: "Sign Up Error", message: "An error occured during Sign Up,\nplease try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func presentSignInErrorAlert() {
        let alert = UIAlertController(title: "Sign In Error", message: "An error occured during Sign In,\nplease try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Password Information Circles
    @IBAction func passwordInfoCircleTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Password Required", message: "Must be at least 6 characters, with at least 1 number.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func confirmPasswordInfoCircleTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirm Password Required", message: "Must be at least 6 characters, with at least 1 number, and must match your password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalForgotPasswordSegue" {
            guard let destinationVC = segue.destination as? ForgotPasswordViewController else { return }
            destinationVC.userController = userController
        }
    }
}

// MARK: - Segmented Control Background & Divider Image
extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(data: image.pngData()!)!
    }
}

// MARK: - Text Field Delegate
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case passwordTextField:
            confirmPasswordTextField.isSecureTextEntry = true
            passwordEyeballButton.isHidden = false
            confirmPasswordEyeballButton.isHidden = true
        case confirmPasswordTextField:
            passwordTextField.isSecureTextEntry = true
            passwordEyeballButton.isHidden = true
            confirmPasswordEyeballButton.isHidden = false
        default:
            passwordTextField.isSecureTextEntry = true
            passwordEyeballButton.isHidden = true
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordEyeballButton.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTextField:
            let (valid, message) = validate(textField)
            
            if valid {
                emailTextField.becomeFirstResponder()
                self.fullNameErrorMessage.text = " "
                return true
            }
            
            self.fullNameErrorMessage.text = message
        case emailTextField:
            let (valid, message) = validate(textField)
            
            if valid {
                passwordTextField.becomeFirstResponder()
                self.emailErrorMessage.text = " "
                return true
            }
            
            self.emailErrorMessage.text = message
        case passwordTextField:
            let (valid, message) = validate(textField)
            
            if valid {
                if loginType == .signup {
                    confirmPasswordTextField.becomeFirstResponder()
                } else {
                    passwordTextField.resignFirstResponder()
                }
                self.passwordErrorMessage.text = " "
                return true
            }
            
            self.passwordErrorMessage.text = message
        case confirmPasswordTextField:
            let (valid, message) = validate(textField)
            
            if valid {
                confirmPasswordTextField.resignFirstResponder()
                self.confirmPasswordErrorMessage.text = " "
                return true
            }
            
            self.confirmPasswordErrorMessage.text = message
        default:
            return true
        }
        return true
    }
}
