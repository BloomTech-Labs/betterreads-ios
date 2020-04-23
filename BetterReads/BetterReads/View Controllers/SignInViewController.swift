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
    let regularFont = UIFont(name: "SourceSansPro-Bold", size: 16)
    let boldFont = UIFont(name: "SourceSansPro-Bold", size: 20)
    let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0), NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Bold", size: 20)]
    let subTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0), NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 16)]

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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomSegmentedControl()
        submitButton.layer.cornerRadius = 5
        
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
                
        configurePasswordTextField()
        configureConfirmTextField()
    }
    
    // FIXME: buttons switch states when clicking into another textfield
    // FIXME: text should always be secured when clicking outside of textfield
    // FIXME: bottom of keyboard should never give option to use mic(?) or emoji
    // FIXME: move button a little to the left (for both textfields)
    private func configurePasswordTextField() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = showPasswordHideButton
        passwordTextField.rightViewMode = .always
        showPasswordHideButton.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.addSubview(showPasswordHideButton)
        //showPasswordHideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        showPasswordHideButton.setImage(eyeballTransparentImage, for: .normal)
        showPasswordHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.0, bottom: 0, right: 0)
        showPasswordHideButton.addTarget(self, action: #selector(tappedPasswordHideButton), for: .touchUpInside)
    }
    
    private func configureConfirmTextField() {
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.rightView = showConfirmHideButton
        confirmPasswordTextField.rightViewMode = .always
        showConfirmHideButton.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.addSubview(showConfirmHideButton)
        //showConfirmHideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        showConfirmHideButton.setImage(eyeballTransparentImage, for: .normal)
        showConfirmHideButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.0, bottom: 0, right: 0)
        showConfirmHideButton.addTarget(self, action: #selector(tappedConfirmHideButton), for: .touchUpInside)
    }
        
    @objc private func tappedPasswordHideButton() {
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
    
    @objc private func tappedConfirmHideButton() {
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
    
    // MARK: - Methods
    
    func setupCustomSegmentedControl() {
        // Change font on the segmented control, add a default font to dismiss warning
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : boldFont ?? UIFont()], for: .selected)
        // Change the background and divider image on the segmented control to a transparent (clear) image in the extension at the bottom of this file
        segmentedControl.setBackgroundImage(segControlBackgroundImage, for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(segControlDividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        // Change the text color on the segmented control for selected and normal states
        segmentedControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        segmentedControl.setTitleTextAttributes(subTitleTextAttributes as [NSAttributedString.Key : Any], for: .normal)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signup
            submitButton.setTitle("Sign Up", for: .normal)
            fullNameTextField.isHidden = false
            fullNameLabel.isHidden = false
            segmentedControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        } else {
            loginType = .signin
            submitButton.setTitle("Sign In", for: .normal)
            fullNameTextField.isHidden = true
            fullNameLabel.isHidden = true
            segmentedControl.setTitleTextAttributes(subTitleTextAttributes as [NSAttributedString.Key : Any], for: .normal)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        print("signUpButtonTapped")
        guard let fullname = fullNameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            !fullname.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            !confirmPassword.isEmpty else {
                //FIXME: Present alert message that textfields are empty
                print("One of the textfields is empty.")
            return
        }
        
        if confirmPassword != password {
            print("\(password) \n \(confirmPassword)")
            let alert = UIAlertController(title: "Passwords do not match.", message: "Please confirm your passwords match.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            return
        }
        
        let user = User(fullName: fullname, email: email, password: password)
        if loginType == .signup {
            userController.signUp(user: user) { (networkError) in
                if let error = networkError {
                    NSLog("Error occured during Sign Up: \(error)")
                } else {
                    let alert = UIAlertController(title: "Sign up successful!", message: "Please sign in.", preferredStyle: .alert)
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
                tappedPasswordHideButton()
                //showPasswordHideButton.setImage(UIImage(systemName: "book.fill"), for: .normal)
            } else {
                tappedConfirmHideButton()
                //showConfirmHideButton.setImage(UIImage(systemName: "book.fill"), for: .normal)
            }
        } else {
            showPasswordHideButton.setImage(eyeballTransparentImage, for: .normal)
            showConfirmHideButton.setImage(eyeballTransparentImage, for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextField {
            fullNameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            confirmPasswordTextField.resignFirstResponder()
            signUpButtonTapped(submitButton)
        }
        return true
    }
}


//import UIKit
//
//enum PasswordStrength: Int {
//    case weak = 1
//    case medium
//    case strong
//}
//
//class PasswordField: UIControl {
//
//    // Public API - these properties are used to fetch the final password and strength values
//    private (set) var password: String = ""
//    private (set) var strength: PasswordStrength = .weak
//
//    private let standardMargin: CGFloat = 8.0
//    private let textFieldContainerHeight: CGFloat = 50.0
//    private let textFieldMargin: CGFloat = 6.0
//    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
//
//    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
//    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
//
//    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
//    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
//
//    // States of the password strength indicators
//    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
//    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
//    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
//    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
//
//    private var titleLabel: UILabel = UILabel()
//    private var textField: UITextField = UITextField()
//    private var showHideButton: UIButton = UIButton()
//    private var weakView: UIView = UIView()
//    private var mediumView: UIView = UIView()
//    private var strongView: UIView = UIView()
//    private var strengthDescriptionLabel: UILabel = UILabel()
//
//    private var showingPassword = false
//
//    func setup() {
//        backgroundColor = bgColor
//
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardMargin).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin).isActive = true
//        titleLabel.text = "ENTER PASSWORD"
//        titleLabel.font = labelFont
//        titleLabel.textColor = labelTextColor
//
//        let textFieldContainerView = UIView()
//        addSubview(textFieldContainerView)
//        textFieldContainerView.backgroundColor = .clear
//        textFieldContainerView.layer.borderColor = textFieldBorderColor.cgColor
//        textFieldContainerView.layer.borderWidth = 2.0
//        textFieldContainerView.layer.cornerRadius = 5.0
//        textFieldContainerView.translatesAutoresizingMaskIntoConstraints = false
//        textFieldContainerView.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0).isActive = true
//        textFieldContainerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
//        trailingAnchor.constraint(equalTo: textFieldContainerView.trailingAnchor, constant: standardMargin).isActive = true
//        textFieldContainerView.heightAnchor.constraint(equalToConstant: textFieldContainerHeight).isActive = true
//
//        textFieldContainerView.addSubview(textField)
//        textField.delegate = self
//        textField.tintColor = textFieldBorderColor
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.isSecureTextEntry = !showingPassword
//        textField.topAnchor.constraint(equalTo: textFieldContainerView.topAnchor, constant: textFieldMargin).isActive = true
//        textField.leadingAnchor.constraint(equalTo: textFieldContainerView.leadingAnchor, constant: textFieldMargin).isActive = true
//        textFieldContainerView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: textFieldMargin).isActive = true
//
//        textFieldContainerView.addSubview(showHideButton)
//        showHideButton.translatesAutoresizingMaskIntoConstraints = false
//        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
//        showHideButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
//        showHideButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: textFieldMargin).isActive = true
//        textFieldContainerView.trailingAnchor.constraint(equalTo: showHideButton.trailingAnchor, constant: textFieldMargin).isActive = true
//        showHideButton.addTarget(self, action: #selector(showHideButtonTapped(_:)), for: .touchUpInside)
//
//        addSubview(weakView)
//        weakView.translatesAutoresizingMaskIntoConstraints = false
//        weakView.backgroundColor = weakColor
//        weakView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
//        weakView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
//        weakView.layer.cornerRadius = colorViewSize.height / 2.0
//
//        addSubview(mediumView)
//        mediumView.translatesAutoresizingMaskIntoConstraints = false
//        mediumView.backgroundColor = unusedColor
//        mediumView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
//        mediumView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
//        mediumView.layer.cornerRadius = colorViewSize.height / 2.0
//
//        addSubview(strongView)
//        strongView.translatesAutoresizingMaskIntoConstraints = false
//        strongView.backgroundColor = unusedColor
//        strongView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
//        strongView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
//        strongView.layer.cornerRadius = colorViewSize.height / 2.0
//
//        let colorStackView = UIStackView(arrangedSubviews: [weakView, mediumView, strongView])
//        addSubview(colorStackView)
//        colorStackView.translatesAutoresizingMaskIntoConstraints = false
//        colorStackView.axis = .horizontal
//        colorStackView.alignment = .fill
//        colorStackView.distribution = .fill
//        colorStackView.spacing = 2.0
//        colorStackView.topAnchor.constraint(equalTo: textFieldContainerView.bottomAnchor, constant: 16.0).isActive = true
//        colorStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
//
//        addSubview(strengthDescriptionLabel)
//        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        strengthDescriptionLabel.leadingAnchor.constraint(equalTo: colorStackView.trailingAnchor, constant: standardMargin).isActive = true
//        strengthDescriptionLabel.centerYAnchor.constraint(equalTo: colorStackView.centerYAnchor).isActive = true
//        bottomAnchor.constraint(equalTo: strengthDescriptionLabel.bottomAnchor, constant: standardMargin).isActive = true
//        strengthDescriptionLabel.text = "Too weak"
//        strengthDescriptionLabel.font = labelFont
//        strengthDescriptionLabel.textColor = labelTextColor
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    @objc func showHideButtonTapped(_ sender: UIButton) {
//        showingPassword.toggle()
//        showHideButton.setImage(UIImage(named: (showingPassword) ? "eyes-open" : "eyes-closed"), for: .normal)
//        textField.isSecureTextEntry = !showingPassword
//    }
//
//    func determinePasswordStrength(with string: String) {
//        var strength = PasswordStrength.weak
//        switch string.count {
//        case 0...9:
//            strength = .weak
//        case 10...19:
//            strength = .medium
//        default:
//            strength = .strong
//        }
//        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: string) {
//            let weaker = strength.rawValue - 1
//            strength = PasswordStrength(rawValue: (weaker >= 1) ? weaker : 1)!
//        }
//        updateStrengthViews(to: strength)
//    }
//
//    func updateStrengthViews(to strength: PasswordStrength) {
//        if strength != self.strength {
//            switch strength {
//            case .weak:
//                strengthDescriptionLabel.text = "Too weak"
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.weakView.backgroundColor = self.weakColor
//                    self.weakView.transform = CGAffineTransform(scaleX: 1.0, y: 1.6)
//                    self.mediumView.backgroundColor = self.unusedColor
//                    self.strongView.backgroundColor = self.unusedColor
//                }) { completed in
//                    UIView.animate(withDuration: 0.1, animations: {
//                        self.weakView.transform = .identity
//                    })
//                }
//            case .medium:
//                strengthDescriptionLabel.text = "Could be stronger"
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.weakView.backgroundColor = self.weakColor
//                    self.mediumView.backgroundColor = self.mediumColor
//                    self.mediumView.transform = CGAffineTransform(scaleX: 1.0, y: 1.6)
//                    self.strongView.backgroundColor = self.unusedColor
//                }) { completed in
//                    UIView.animate(withDuration: 0.1, animations: {
//                        self.mediumView.transform = .identity
//                    })
//                }
//            case .strong:
//                strengthDescriptionLabel.text = "Strong password"
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.weakView.backgroundColor = self.weakColor
//                    self.mediumView.backgroundColor = self.mediumColor
//                    self.strongView.backgroundColor = self.strongColor
//                    self.strongView.transform = CGAffineTransform(scaleX: 1.0, y: 1.6)
//                }) { completed in
//                    UIView.animate(withDuration: 0.1, animations: {
//                        self.strongView.transform = .identity
//                    })
//                }
//            }
//        }
//
//        self.strength = strength
//    }
//}
//
//extension PasswordField: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let oldText = textField.text!
//        let stringRange = Range(range, in: oldText)!
//        let newText = oldText.replacingCharacters(in: stringRange, with: string)
//        determinePasswordStrength(with: newText)
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return false
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text = textField.text {
//            password = text
//        }
//        sendActions(for: .valueChanged)
//    }
//}
