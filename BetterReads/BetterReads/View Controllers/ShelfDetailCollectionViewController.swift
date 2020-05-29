//
//  ShelfDetailCollectionViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ShelfDetailCell"

class ShelfDetailCollectionViewController: UICollectionViewController {

    // MARK: - Properties

    /// Holds index passed from MyLibraryCVC so you know which array from allShelvesArray to use
    var allBooksIndex: Int?

    /// Holds index passed from MyLibraryCVC so you know which array from userShelves.books to use
    var userShelvesIndex: Int?

    // MARK: - View Life Cylce

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .trinidadOrange
        // Back button title for next screen
        let backItem = UIBarButtonItem()
        backItem.title = "" // now only the arrow is showing
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // if the shelf is from the default shelves
        if let allBooksIndex = allBooksIndex {
            return UserController.sharedLibraryController.allShelvesArray[allBooksIndex].count
        }

        // or if it's a custom shelf
        if let userShelvesIndex = userShelvesIndex,
            let booksInShelf = UserController.sharedLibraryController.userShelves[userShelvesIndex].books {
            return booksInShelf.count
        }
        return 100 // This should never run, but just in case
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? ShelfDetailCollectionViewCell
            else { return UICollectionViewCell() }

        if let allBooksIndex = allBooksIndex {
            print("Default Shelf - index \(allBooksIndex)")
            cell.userBook = UserController.sharedLibraryController.allShelvesArray[allBooksIndex][indexPath.item]
        }

        if let userShelvesIndex = userShelvesIndex {
            print("Custom Shelf - index \(userShelvesIndex)")
            let book = UserController.sharedLibraryController.userShelves[userShelvesIndex].books?[indexPath.item]
            cell.userBookOnShelf = book
        }
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //ShelfToDetail
        if segue.identifier == "ShelfToDetail" {
            print("ShelfToDetail")
            if let detailVC = segue.destination as? BookDetailViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let cell = collectionView.cellForItem(at: indexPath) as? ShelfDetailCollectionViewCell
                detailVC.bookCoverImageView.image = cell?.shelfImageView.image
                detailVC.blurredBackgroundView.image = cell?.shelfImageView.image

                // Book in Default shelf
                if let possibleAllBooksIndex = allBooksIndex {
                    print("section 1, index \(possibleAllBooksIndex)")
                    detailVC.userBook = UserController.sharedLibraryController.allShelvesArray[possibleAllBooksIndex][indexPath.item]
                }

                // Book in Custom shelf
                if let possibleUserShelvesIndex = userShelvesIndex {
                    print("section 2, index \(possibleUserShelvesIndex)")
                    detailVC.userBookOnShelf = UserController.sharedLibraryController.userShelves[possibleUserShelvesIndex].books?[indexPath.item]
                }
            }
        }
    }
}

extension ShelfDetailCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }

    // MARK: Flow Layout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let insets = self.collectionView(collectionView,
                                         layout: collectionViewLayout,
                                         insetForSectionAt: 0)
        let horizontalInsets = insets.left + insets.right
        let itemSpacing = (self.collectionView(collectionView,
                                               layout: collectionViewLayout,
                                               minimumInteritemSpacingForSectionAt: 0)) * (itemsPerRow - 1)
        let width = (collectionView.frame.width - horizontalInsets - itemSpacing) / itemsPerRow
        return CGSize(width: width, height: width * 1.3)
    }
}
