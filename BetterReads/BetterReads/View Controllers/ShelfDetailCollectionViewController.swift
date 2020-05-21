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

    var allBooksIndex: Int?
    var userShelvesIndex: Int?

    // FIXME: delete add button on shelf detail screen later and these outlets
    @IBOutlet var addBookToShelfButtonLabel: UIBarButtonItem!

    @IBAction func addBookToShelfTapped(_ sender: UIBarButtonItem) {
        print("addBookToShelfTapped")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .trinidadOrange
        addBookToShelfButtonLabel.isEnabled = false
        addBookToShelfButtonLabel.tintColor = .clear
        // Back button title for next screen
        let backItem = UIBarButtonItem()
        backItem.title = "" // now only the arrow is showing
        navigationItem.backBarButtonItem = backItem
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
                if let possibleAllBooksIndex = allBooksIndex {
                    print("section 1, index \(possibleAllBooksIndex)")
                    detailVC.userBook = UserController.sharedLibraryController.allShelvesArray[possibleAllBooksIndex][indexPath.item]
                }

                if let possibleUserShelvesIndex = userShelvesIndex {
                    print("section 2, index \(possibleUserShelvesIndex)")
                }
                //detailVC.userBook = UserController.sharedLibraryController.allShelvesArray[allBooksIndex ?? 0][indexPath.item]
                // FIXME: pass in controller that has CRUD methods to add books
            }
        }
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
        return 100 // This should never run
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
            cell.userBookOnShelf = UserController.sharedLibraryController.userShelves[userShelvesIndex].books?[indexPath.item]
            // cell.userBookOnShelf = UserController.sharedLibraryController....
        }
//        guard let allBooksIndex = allBooksIndex else { return cell }
//        cell.userBook = UserController.sharedLibraryController.allShelvesArray[allBooksIndex][indexPath.item]
        return cell
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
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
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
        return CGSize(width: width, height: width * 1.4)
    }

}
