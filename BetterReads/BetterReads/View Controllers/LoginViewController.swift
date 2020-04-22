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
    let segControlBackgroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
    let segControlDividerImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
    let regularFont = UIFont(name: "SourceSansPro-Bold", size: 16)
    let boldFont = UIFont(name: "SourceSansPro-Bold", size: 20)
    //let tundraColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0) // Tundra #404040
    let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0), NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Bold", size: 20)]
    let subTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0), NSAttributedString.Key.font : UIFont(name: "SourceSansPro-Regular", size: 16)]

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
        // Change the font on the segmented control
        // boldFont ?? UIFont()  no default generated a warning
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : boldFont ?? UIFont()], for: .selected)
        // Change the background and divider image on the segmented control to a transparent (clear) image
        segmentedControl.setBackgroundImage(segControlBackgroundImage, for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(segControlDividerImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        // Change the text color on the segmented control
        segmentedControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
        segmentedControl.setTitleTextAttributes(subTitleTextAttributes as [NSAttributedString.Key : Any], for: .normal)
        submitButton.layer.cornerRadius = 5
    }
        
    // MARK: - Methods
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        print("segmented control value changed")
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
        submitButton.performFlare()
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        print("signUpTapped")
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

// Segmented Control Background & Divider Image
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
