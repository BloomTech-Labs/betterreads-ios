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
It’s great to have you!
Search for your favorite books and add them to your library collection.
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
        self.welcomeUser.text = "Hello, \(UserController.shared.user?.fullName.first ?? "there")!"
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        middleCollectionView.delegate = self
        middleCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        if UserController.shared.isNewUser ?? false {
            welcomeMessage.text = welcomeNewUserMessageText
        } else {
            welcomeMessage.text = welcomeReturningUserMessageText
        }
        UserController.shared.getRecommendations { (error) in
            var title = "Recommendations Error"
            var message = "An error occurred while getting recommendations."
            if UserController.shared.isNewUser == true {
                title = "Welcome to BetterReads!"
                message = "To help us make better recommendations, search for and add books to your library."
            }
            if let error = error {
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                NSLog("Error occured during Get Recommendations: \(error)")
            }
            DispatchQueue.main.async {
                self.topCollectionView.reloadData()
            }
        }

        UserController.sharedLibraryController.fetchCustomShelves { (error) in
            if let error = error {
                print("Error fetching shelves in HomeVC \(error)")
            } else {
                DispatchQueue.main.async {
                    print("shelves count: \(UserController.sharedLibraryController.userShelves.count)")
                    UserController.sharedLibraryController.fetchRecommendedBooks { (_) in
                        DispatchQueue.main.async {
                            print("finished recs for middle")
                            self.middleCollectionView.reloadData()
                        }
                    }
                }
            }
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
            cell.bookCoverImageView.image = UIImage().chooseDefaultBookImage()
            guard let books = UserController.shared.recommendedBooks else { return cell }
            cell.book = books[indexPath.item]
            return cell
        } else if collectionView == self.middleCollectionView {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "MiddleCollectionCell",
                                     for: indexPath
                ) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            cell.bookCoverImageView.image = UIImage().chooseDefaultBookImage()
            guard let books = UserController.sharedLibraryController.recommendationsForRandomShelf else { return cell }
            cell.book = books[indexPath.item]
            return cell
        } else if collectionView == self.bottomCollectionView {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "BottomCollectionCell",
                                     for: indexPath
                ) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            cell.bookCoverImageView.image = UIImage().chooseDefaultBookImage()
            return cell
        }
        return RecommendationCollectionViewCell()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookDetailSegue" {
            if let detailVC = segue.destination as? BookDetailViewController {
                guard let books = UserController.shared.recommendedBooks,
                    let indexPath = topCollectionView.indexPathsForSelectedItems?.first else { return }
                let book = books[indexPath.row]
                detailVC.book = book
                let cell = topCollectionView.cellForItem(at: indexPath) as? RecommendationCollectionViewCell
                detailVC.bookCoverImageView.image = cell?.bookCoverImageView.image
                detailVC.blurredBackgroundView.image = cell?.bookCoverImageView.image
                // FIXME: pass in controller that has CRUD methods to add books
                // Back button title for next screen
                let backItem = UIBarButtonItem()
                backItem.title = "" // now only the arrow is showing
                navigationItem.backBarButtonItem = backItem
            }
//            guard let barViewControllers = segue.destination as? UITabBarController,
//                let nav = barViewControllers.viewControllers?[0] as? UINavigationController,
//                let _ = nav.topViewController as? BookDetailViewController else {
//                //FIXME: - Better error handling and alert
//                //FIXME: - Give book to destinationVC when BookDetails is built
//                return
//            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension UIViewController: UICollectionViewDelegate {
}
