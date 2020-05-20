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

    //var libraryController: LibraryController?
    var tempShelfDetailCount: Int = 1
    var allBooksIndex: Int?

    @IBOutlet var addBookToShelfButtonLabel: UIBarButtonItem!
    @IBAction func addBookToShelfTapped(_ sender: UIBarButtonItem) {
        print("addBookToShelfTapped")
        tempShelfDetailCount += 1
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .trinidadOrange
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
                //detailVC.book = libraryController?.myBooksArray[indexPath.row]
                let cell = collectionView.cellForItem(at: indexPath) as? ShelfDetailCollectionViewCell
                detailVC.bookCoverImageView.image = cell?.shelfImageView.image
                detailVC.blurredBackgroundView.image = cell?.shelfImageView.image
                //detailVC.libraryController = libraryController
                detailVC.userBook = UserController.sharedLibraryController.allShelvesArray[allBooksIndex ?? 0][indexPath.item]
                // FIXME: pass in controller that has CRUD methods to add books
            }
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserController.sharedLibraryController.allShelvesArray[allBooksIndex ?? 0].count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? ShelfDetailCollectionViewCell
            else { return UICollectionViewCell() }
        guard let allBooksIndex = allBooksIndex else { return cell }
        cell.userBook = UserController.sharedLibraryController.allShelvesArray[allBooksIndex][indexPath.item]
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
        print("sizeForItemAt = \(CGSize(width: width, height: width * 1.3))")
        print("safeAreaLayoutGuide = \(self.view.safeAreaLayoutGuide)")
        return CGSize(width: width, height: width * 1.4)
    }
}
