//
//  HomeViewController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/4/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit
import Nuke

class HomeViewController: UIViewController, UICollectionViewDataSource {
    // MARK: - Properties
    let welcomeNewUserMessageText = """
It’s great to have you! Discover interesting stories and unique perspectives from the suggestions below.
Already a book nerd? Add your favorites to your library collection.
"""
    let welcomeReturningUserMessageText = """
Welcome back!
Flip through the tailored recommendations below from a variety of authors and storytellers.
"""
    // MARK: - Outlets
    @IBOutlet weak var welcomeUser: UILabel!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var topRecommendationLabel: UILabel!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var middleRecommendationLabel: UILabel!
    @IBOutlet weak var middleCollectionView: UICollectionView!
    @IBOutlet weak var bottomRecommendationLabel: UILabel!
    @IBOutlet weak var bottomCollectionView: UICollectionView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeUser.text = "Hello, \(UserController.shared.user?.fullName ?? "there")!"
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        middleCollectionView.delegate = self
        middleCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self

        if (UserController.shared.isNewUser ?? false) {
            welcomeMessage.text = welcomeNewUserMessageText
        } else {
            welcomeMessage.text = welcomeReturningUserMessageText
        }
        UserController.shared.getRecommendations { (error) in
            if let error = error {
                let alert = UIAlertController(title: "Recommendations Error",
                                              message: "An error occurred while getting recommendations.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                NSLog("Error occured during Get Recommendations: \(error)")
            }
            self.topCollectionView.reloadData()
        }
    }
    // MARK: - Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.topCollectionView {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "TopCollectionCell",
                                     for: indexPath
                ) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            guard let books = UserController.shared.recommendedBooks else { return cell }
            cell.book = books[indexPath.item]
            return cell
        } else if collectionView == self.middleCollectionView {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "MiddleCollectionCell",
                                     for: indexPath
                ) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            return cell
        } else if collectionView == self.bottomCollectionView {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "BottomCollectionCell",
                                     for: indexPath
                ) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            return cell
        }
        return RecommendationCollectionViewCell()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookDetailSegue" {
            guard let barViewControllers = segue.destination as? UITabBarController,
                let nav = barViewControllers.viewControllers?[0] as? UINavigationController,
                let _ = nav.topViewController as? BookDetailViewController else {
                //FIXME: - Better error handling and alert
                //FIXME: - Give book to destinationVC when BookDetails is built
                return
            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension UIViewController: UICollectionViewDelegate {
}
