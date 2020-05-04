//
//  HomeViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/4/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    var userController: UserController?
    
    //MARK: - Outlets
    @IBOutlet weak var welcomeUser: UILabel!
    @IBOutlet weak var topRecommendationLabel: UILabel!
    @IBOutlet weak var middleRecommendationLabel: UILabel!
    @IBOutlet weak var bottomRecommendationLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        guard let userController = userController else { return }
        userController.getRecommendations { (error) in
            if let error = error {
            let alert = UIAlertController(title: "Recommendations Error", message: "An error occurred while getting recommendations.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            NSLog("Error occured during Get Recommendations: \(error)")
            }
        }
    }
    
    //MARK: - Methods

    

}
