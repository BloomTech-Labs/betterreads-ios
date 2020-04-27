//
//  SignInViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez & Ciara "CC" Beitel on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    enum LoginType {
        case signup
        case signin
    }
    
    var loginType = LoginType.signup
    var userController = UserController()
    let segControlBackgroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
    let segControlDividerImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
    let eyeballTransparentImage = UIImage(color: .clear, size: CGSize(width: 1, height: 1))
    let regularFont = UIFont(name: "SourceSansPro-Regular", size: 16)
    let semiBoldFont = UIFont(name: "SourceSansPro-SemiBold", size: 20)
    let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tundra, NSAttributedString.Key.font : UIFont(name: "SourceSansPro-SemiBold", size: 20)]
    let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tundra, NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 16)]

    private var showPasswordHideButton: UIButton = UIButton()
    private var passwordIsHidden = false
    private var showConfirmHideButton: UIButton = UIButton()
    private var confirmIsHidden = false
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var fullNameErrorMessage: UILabel!
    @IBOutlet weak var emailErrorMessage: UILabel!
    @IBOutlet weak var passwordErrorMessage: UILabel!
    @IBOutlet weak var confirmPasswordErrorMessage: UILabel!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var passwordInfoCircle: UIButton!
    @IBOutlet weak var confirmPasswordInfoCircle: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
        textFieldDelegates()
        forgotPassword.isHidden = true
    }
    
    // MARK: - Methods
    private func setupUIElements() {
        hideErrorMessagesOnLoad()
        setupCustomSegmentedControl()
        configurePasswordTextField()
        configureConfirmTextField()
        submitButton.layer.cornerRadius = 5
    }
    
    private func hideErrorMessagesOnLoad() {
        fullNameErrorMessage.text = ""
        emailErrorMessage.text = ""
        passwordErrorMessage.text = ""
        confirmPasswordErrorMessage.text = ""
    }
    
    private func textFieldDelegates() {
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
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
        hideErrorMessagesOnLoad()
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
        hideErrorMessagesOnLoad()
        segmentedControl.selectedSegmentIndex = 1
        forgotPassword.isHidden = false
        passwordInfoCircle.isHidden = true
        confirmPasswordInfoCircle.isHidden = true
        passwordTextField.returnKeyType = .done
        passwordTextField.textContentType = .password
        emailTextField.textContentType = .emailAddress
    }

    // MARK: - Configure Text Fields for show/hide Password
    // FIXME: buttons switch states when clicking into another textfield
    // FIXME: text should always be secured when clicking outside of textfield
    // FIXME: bottom of keyboard should never give option to use mic(?) or emoji
    private func configurePasswordTextField() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = showPasswordHideButton
        passwordTextField.rightViewMode = .always
        showPasswordHideButton.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.addSubview(showPasswordHideButton)
        //showPasswordHideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        showPasswordHideButton.setImage(eyeballTransparentImage, for: .normal)
        showPasswordHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20.0, bottom: 0, right: 5.0)
        showPasswordHideButton.addTarget(self, action: #selector(tappedPasswordEyeballButton), for: .touchUpInside)
    }
    
    private func configureConfirmTextField() {
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.rightView = showConfirmHideButton
        confirmPasswordTextField.rightViewMode = .always
        showConfirmHideButton.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.addSubview(showConfirmHideButton)
        //showConfirmHideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        showConfirmHideButton.setImage(eyeballTransparentImage, for: .normal)
        showConfirmHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20.0, bottom: 0, right: 5.0)
        showConfirmHideButton.addTarget(self, action: #selector(tappedConfirmEyeballButton), for: .touchUpInside)
    }
        
    @objc private func tappedPasswordEyeballButton() {
        //showPasswordHideButton.isSelected.toggle()
        if passwordIsHidden {
            // Show
            showPasswordHideButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = false
            passwordIsHidden = false
        }
        else {
            // Hide
            showPasswordHideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            passwordTextField.isSecureTextEntry = true
            passwordIsHidden = true
        }
    }
    
    @objc private func tappedConfirmEyeballButton() {
        //showConfirmHideButton.isSelected.toggle()
        if confirmIsHidden {
            // Show
            showConfirmHideButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            confirmPasswordTextField.isSecureTextEntry = false
            confirmIsHidden = false
        }
        else {
            // Hide
            showConfirmHideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            confirmPasswordTextField.isSecureTextEntry = true
            confirmIsHidden = true
        }
    }
    
    // MARK: - Validate text in Text Fields
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        validate {
            signUpOrSignInUser()
        }
    }
        
    private func validate(field: String? = nil, completion: () -> ()) {
        hideErrorMessagesOnLoad()
        
        do {
            switch field {
            case "fullName":
                // if signIn, don't validate fullName textfield
                if segmentedControl.selectedSegmentIndex == 1 {
                    completion()
                }
                let _ = try fullNameTextField.validatedText(validationType: .required(field: "fullName"))
                completion()
            case "email":
                let _ = try emailTextField.validatedText(validationType: .email(field: "email"))
                completion()
            case "password":
                let _ = try passwordTextField.validatedText(validationType: .password(field: "password"))
                completion()
            case "confirmPassword":
                // if signIn, don't validate confirmPassword textfield
                if segmentedControl.selectedSegmentIndex == 1 {
                    completion()
                }
                let confirmPassword = try confirmPasswordTextField.validatedText(validationType: .password(field: "confirmPassword"))
                let password = try passwordTextField.validatedText(validationType: .password(field: "password"))
                if confirmPassword != password {
                    print("\(password) \n \(confirmPassword)")
                    confirmPasswordErrorMessage.text = "Passwords do not match."
                    return
                }
                completion()
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
                        confirmPasswordErrorMessage.text = "Passwords do not match."
                        return
                    }
                }
                completion()
            }
        } catch(let error) {
            let convertedError = (error as! ValidationError)
            
            switch convertedError.fieldName {
            case "fullName":
                fullNameErrorMessage.text = convertedError.message
            case "email":
                emailErrorMessage.text = convertedError.message
            case "password":
                passwordErrorMessage.text = convertedError.message
            case "confirmPassword":
                confirmPasswordErrorMessage.text = convertedError.message
            default:
                return
            }
        }
    }
    
    private func signUpOrSignInUser() {
        guard let fullName = fullNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        let user = User(fullName: fullName, email: email, password: password)
        if loginType == .signup {
            userController.signUp(user: user) { (networkError) in
                if let error = networkError {
                    self.presentSignUpErrorAlert()
                    NSLog("Error occured during Sign Up: \(error)")
                } else {
                    self.userController.signIn(email: email, password: password) { (networkError) in
                        if let error = networkError {
                            self.setUpSignInForm()
                            self.presentSignInErrorAlert()
                            NSLog("Error occured during Sign In: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                self.seg()
                            }
                        }
                    }
                }
            }
        } else if loginType == .signin {
            userController.signIn(email: email, password: password) { (networkError) in
                if let error = networkError {
                    self.presentSignInErrorAlert()
                    NSLog("Error occured during Sign In: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.seg()
                    }
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
    
    // MARK: - Forget Password
    @IBAction func forgetPasswordTapped() {
        //FIXME: - Add web link here
        print("Forgot your password button was tapped.")
    }
    
    // MARK: - Navigation
    private func seg() {
        print("Called seg()")
        performSegue(withIdentifier: "SignInSuccessSegue", sender: self)
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
        // FIXME: currently only hiding buttons when clicking one of the other 2 fields
        // when it should hide them when clicking ANY other textfield
        if textField == passwordTextField || textField == confirmPasswordTextField {
            if textField == passwordTextField {
                tappedPasswordEyeballButton()
                //showPasswordHideButton.setImage(UIImage(systemName: "book.fill"), for: .normal)
            } else {
                tappedConfirmEyeballButton()
                //showConfirmHideButton.setImage(UIImage(systemName: "book.fill"), for: .normal)
            }
        } else {
            showPasswordHideButton.setImage(eyeballTransparentImage, for: .normal)
            showConfirmHideButton.setImage(eyeballTransparentImage, for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextField {
            validate(field: "fullName") {
                fullNameTextField.resignFirstResponder()
                emailTextField.becomeFirstResponder()
            }
        } else if textField == emailTextField {
            validate(field: "email") {
                emailTextField.resignFirstResponder()
                passwordTextField.becomeFirstResponder()
            }
        } else if textField == passwordTextField {
            validate(field: "password") {
                if loginType == .signup {
                    passwordTextField.resignFirstResponder()
                    confirmPasswordTextField.becomeFirstResponder()
                } else {
                    passwordTextField.resignFirstResponder()
                    guard let fullNameText = fullNameTextField.text,
                        let emailText = emailTextField.text,
                        let passwordText = passwordTextField.text,
                        let confirmPasswordText = confirmPasswordTextField.text else { return }
                    if emailText.isEmpty || passwordText.isEmpty {
                        return
                    } else {
                        submitButton.backgroundColor = UIColor.catalinaBlue
                    }
                }
            }
        } else if textField == confirmPasswordTextField {
            validate(field: "confirmPassword") {
                confirmPasswordTextField.resignFirstResponder()
                guard let fullNameText = fullNameTextField.text,
                    let emailText = emailTextField.text,
                    let passwordText = passwordTextField.text,
                    let confirmPasswordText = confirmPasswordTextField.text else { return }
                if fullNameText.isEmpty || emailText.isEmpty || passwordText.isEmpty || confirmPasswordText.isEmpty {
                    return
                } else {
                    submitButton.backgroundColor = UIColor.catalinaBlue
                }
            }
        }
        return true
    }
}
