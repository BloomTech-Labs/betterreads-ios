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
                let indexPath = collectionView.indexPathsForSelectedItems?.first {
                if indexPath.section == 0 {
                    print("DEFAULT SECTION, index \(indexPath.row) of allBooks")
                    shelfDetailVC.allBooksIndex = indexPath.row
                    // pass in the indexPath for allBooksInded
                }
                if indexPath.section == 1 {
                    print("CUSTOM SHELF, index \(indexPath.row) of userShelves")
                    shelfDetailVC.userShelvesIndex = indexPath.row
                    // pass in the indexPath for customShelvesIndex (used with userShelves)
                }
                //shelfDetailVC.allBooksIndex = indexPath.row
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return UserController.sharedLibraryController.allShelvesArray.count
        default:
            return UserController.sharedLibraryController.userShelves.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? LibraryCollectionViewCell
            else { return UICollectionViewCell() }

        if indexPath.section == 0 {
            let allUserBooks = UserController.sharedLibraryController.allShelvesArray[indexPath.item]
            switch indexPath.item {
            case 0:
                cell.shelfNameLabel.text = "My Books (\(allUserBooks.count))"
            case 1:
                cell.shelfNameLabel.text = "To be read (\(allUserBooks.count))"
            case 2:
                cell.shelfNameLabel.text = "In progress (\(allUserBooks.count))"
            case 3:
                cell.shelfNameLabel.text = "Finished (\(allUserBooks.count))"
            default:
                cell.shelfNameLabel.text = "Empty Shelf (\(allUserBooks.count))"
            }
            cell.allUserBooks = allUserBooks
            return cell
        } else if indexPath.section == 1 {
            let customShelf = UserController.sharedLibraryController.userShelves[indexPath.item]
            cell.customShelf = customShelf
            cell.shelfNameLabel.text = "\(customShelf.shelfName ?? "Empty Shelf") (\(customShelf.books?.count ?? 0))"
            return cell
        }
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
