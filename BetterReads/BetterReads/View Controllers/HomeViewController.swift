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
    var animationViewController: AnimationViewController!
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
    @IBOutlet weak var containerView: UIView!
    var bestSellers = [Book]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeUser.text = "Hello, \(UserController.shared.user?.fullName.first ?? "there")!"
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topRecommendationLabel.text = "New York Times Best Sellers"
        middleCollectionView.delegate = self
        middleCollectionView.dataSource = self
        middleRecommendationLabel.text = "Based on your library"
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomRecommendationLabel.text = "Based on your shelves"
        let backItem = UIBarButtonItem() // Back button title for next screen
        backItem.title = "" // now only the arrow is showing
        navigationItem.backBarButtonItem = backItem
        if UserController.shared.isNewUser ?? false {
            welcomeMessage.text = welcomeNewUserMessageText
        } else {
            welcomeMessage.text = welcomeReturningUserMessageText
        }
        fetchPopularRecommendations()
        fetchUserRecommendations()
        fetchShelfRecommendations()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard containerView.isHidden == false else { return }
        UIView.animate(withDuration: 1, delay: 4, options: .curveLinear, animations: {
            self.containerView.alpha = 0
        }) { (_) in
            self.containerView.isHidden = true
        }
    }
    /// Fetches recommendations based on the user's library then reloads middleCollectionView
    private func fetchUserRecommendations() {
        UserController.shared.getRecommendations { (error) in
            var title = "Recommendations Error"
            var message = "An error occurred while getting recommendations."
            if UserController.shared.isNewUser == true {
                title = "Welcome to BetterReads!"
                message = "To help us make better recommendations, search for and add books to your library."
            }
            if let error = error {
                self.showBasicAlert(alertText: title, alertMessage: message, actionTitle: "Okay")
                NSLog("Error occured during Get Recommendations: \(error)")
            }
            DispatchQueue.main.async {
                self.middleCollectionView.reloadData()
            }
        }
    }
    /// Fetches recommendations based on a random custom shelf then reloads bottomCollectionView
    private func fetchShelfRecommendations() {
        UserController.sharedLibraryController.fetchCustomShelves { (error) in
            if let error = error {
                print("Error fetching shelves in HomeVC \(error)")
            } else {
                DispatchQueue.main.async {
                    UserController.sharedLibraryController.fetchRecommendedBooks { (_) in
                        DispatchQueue.main.async {
                            print("finished recs for middle")
                            self.bottomCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    /// Fetches recommendations based on New York Times Best Sellers then reloads topCollectionView
    private func fetchPopularRecommendations() {
        SearchController.fetchNYTBestSellers { (result) in
            DispatchQueue.main.async {
                guard let result = result else { return }
                self.bestSellers = result
                self.topCollectionView.reloadData()
            }
        }
    }

    // MARK: - Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case topCollectionView:
            return bestSellers.count
        case middleCollectionView:
            guard let recommendedBooks = UserController.shared.recommendedBooks else {
                return 5
            }
            return recommendedBooks.count
        case bottomCollectionView:
            guard let recsFromShelf = UserController.sharedLibraryController.recommendationsForRandomShelf else {
                return 5
            }
            return recsFromShelf.count
        default:
            return 5
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.topCollectionView {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "TopCollectionCell",
                                     for: indexPath
                ) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            cell.bookCoverImageView.image = UIImage().chooseDefaultBookImage()
            let books = bestSellers
            cell.book = books[indexPath.item]
            return cell
        } else if collectionView == self.middleCollectionView {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "MiddleCollectionCell",
                                     for: indexPath
                ) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            cell.bookCoverImageView.image = UIImage().chooseDefaultBookImage()
            guard let books = UserController.shared.recommendedBooks else { return cell }
            cell.book = books[indexPath.item]
            return cell
        } else if collectionView == self.bottomCollectionView {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "BottomCollectionCell",
                                     for: indexPath
                ) as? RecommendationCollectionViewCell ?? RecommendationCollectionViewCell()
            cell.bookCoverImageView.image = UIImage().chooseDefaultBookImage()
            guard let books = UserController.sharedLibraryController.recommendationsForRandomShelf else {return cell}
            cell.book = books[indexPath.item]
            return cell
        }
        return RecommendationCollectionViewCell()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // NYT Best Sellers - topCollectionView
        if segue.identifier == "ShowBookDetailSegue" {
            if let detailVC = segue.destination as? BookDetailViewController {
                guard let indexPath = topCollectionView.indexPathsForSelectedItems?.first else { return }
                let books = bestSellers
                let book = books[indexPath.row]
                detailVC.book = book
                let cell = topCollectionView.cellForItem(at: indexPath) as? RecommendationCollectionViewCell
                detailVC.bookCoverImageView.image = cell?.bookCoverImageView.image
                detailVC.blurredBackgroundView.image = cell?.bookCoverImageView.image
            }
        }
        // User Library - middleCollectionView
        if segue.identifier == "ShowBookDetailSegue2" {
            if let detailVC = segue.destination as? BookDetailViewController {
                guard let books = UserController.shared.recommendedBooks,
                    let indexPath = middleCollectionView.indexPathsForSelectedItems?.first else { return }
                let book = books[indexPath.row]
                detailVC.book = book
                let cell = middleCollectionView.cellForItem(at: indexPath) as? RecommendationCollectionViewCell
                detailVC.bookCoverImageView.image = cell?.bookCoverImageView.image
                detailVC.blurredBackgroundView.image = cell?.bookCoverImageView.image
            }
        }
        // User Shelves - bottomCollectionView
        if segue.identifier == "ShowBookDetailSegue3" {
            if let detailVC = segue.destination as? BookDetailViewController {
                guard let books = UserController.sharedLibraryController.recommendationsForRandomShelf,
                    let indexPath = bottomCollectionView.indexPathsForSelectedItems?.first else { return }
                let book = books[indexPath.row]
                detailVC.book = book
                let cell = bottomCollectionView.cellForItem(at: indexPath) as? RecommendationCollectionViewCell
                detailVC.bookCoverImageView.image = cell?.bookCoverImageView.image
                detailVC.blurredBackgroundView.image = cell?.bookCoverImageView.image
            }
        }
    }
}

// MARK: UICollectionViewDelegate
extension UIViewController: UICollectionViewDelegate {
}
