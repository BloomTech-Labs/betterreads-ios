//
//  HomeViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/4/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource {
    
    //MARK: - Properties
    var userController: UserController?
    
    //MARK: - Outlets
    @IBOutlet weak var welcomeUser: UILabel!
    @IBOutlet weak var topRecommendationLabel: UILabel!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var middleRecommendationLabel: UILabel!
    @IBOutlet weak var middleCollectionView: UICollectionView!
    @IBOutlet weak var bottomRecommendationLabel: UILabel!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserContoller()
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        middleCollectionView.delegate = self
        middleCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        addNavBarImage()
    }
    
    //MARK: - Methods
    private func addNavBarImage() {
        let navController = navigationController!
        let image = UIImage(named: "BetterReads-Logo_Orange.png")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    
    private func setupUserContoller() {
        guard let userController = userController else {
            return }
        self.welcomeUser.text = "Hello, \(userController.user?.fullName ?? "there")!"
        userController.getRecommendations { (error) in
            if let error = error {
            let alert = UIAlertController(title: "Recommendations Error", message: "An error occurred while getting recommendations.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            NSLog("Error occured during Get Recommendations: \(error)")
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionCell", for: indexPath) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            
            //cell.bookCoverImageView.image = UIImage(
            
            return cell
        } else if collectionView == self.middleCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiddleCollectionCell", for: indexPath) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            return cell
        } else if collectionView == self.bottomCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCollectionCell", for: indexPath) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            return cell
        }
        return RecommendationCollectionViewCell()
    }
}

//// MARK: UICollectionViewDataSource
//extension UIViewController: UICollectionViewDataSource {
//    public func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.top
//    }
//}

// MARK: UICollectionViewDelegate
extension UIViewController: UICollectionViewDelegate {
    
}

