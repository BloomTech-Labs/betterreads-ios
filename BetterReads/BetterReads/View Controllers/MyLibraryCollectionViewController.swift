//
//  MyLibraryCollectionViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LibraryCell"

class MyLibraryCollectionViewController: UICollectionViewController {
    var tempShelfCount: Int = 1
    let libraryController = LibraryController()
    // FIXME: change system color to trinidadOrange?
    // FIXME: add either an alert controller pop up to
    // make a new shelf or use small(?) modal pop up instead?
    @IBOutlet var addShelfButtonLabel: UIBarButtonItem!
    @IBAction func addShelfButtonTapped(_ sender: UIBarButtonItem) {
        print("addShelfButtonTapped")
        present(alertController, animated: true)
    }
    fileprivate lazy var alertController: UIAlertController = {
        let alertController = UIAlertController(title: "Create new shelf",
                                                message: "Enter shelf name below", preferredStyle: .alert)
        alertController.addTextField { textField in
            self.alertTextField = textField
        }
        self.alertTextField?.placeholder = "maximum 15 characters"
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print(self.alertTextField?.text ?? "")
            self.createNewShelf()
            self.alertTextField?.text = ""
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("cancel button tapped, do cancel logic in here")
            self.alertTextField?.text = ""
        }))
        return alertController
    }()
    fileprivate var alertTextField: UITextField?
    private func createNewShelf() {
        print("createNewShelf called, textField text = \(alertTextField?.text ?? "nil")")
        tempShelfCount += 1
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LibraryToShelf" {
            print("LibraryToShelf")
            if let shelfDetailVC = segue.destination as? ShelfDetailCollectionViewController,
                let _ = collectionView.indexPathsForSelectedItems?.first {
                // FIXME: pass in controller so user can add book to my books or other shelf
                shelfDetailVC.libraryController = libraryController
                //let cell = collectionView.itemForRow(at: indexPath) as? SearchResultTableViewCell
            }
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1//libraryController.myBooksArray.count//tempShelfCount
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? LibraryCollectionViewCell
            else { return UICollectionViewCell() }
        let allUserBooks = libraryController.allShelvesArray[indexPath.item]
        cell.allUserBooks = allUserBooks
        // FIXME: downcast as LibraryCollectionViewCell
        // Configure the cell
        return cell
    }
}

extension MyLibraryCollectionViewController: UICollectionViewDelegateFlowLayout {
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
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: 0)
        let horizontalInsets = insets.left + insets.right
        let itemSpacing = (self.collectionView(collectionView,
                                               layout: collectionViewLayout,
                                               minimumInteritemSpacingForSectionAt: 0)) * (itemsPerRow - 1)
        let width = (collectionView.frame.width - horizontalInsets - itemSpacing) / itemsPerRow
        return CGSize(width: width, height: width * 1.4)
    }
}
