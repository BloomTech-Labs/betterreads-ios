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

    // MARK: - Properties

    /// This is currently made transparent and disabled since we could not fully implement adding a custom shelf
    @IBOutlet var addShelfButtonLabel: UIBarButtonItem!

    /// Presents the user with an alert that lets them create a custom shelf with a name
    @IBAction func addShelfButtonTapped(_ sender: UIBarButtonItem) {
        print("addShelfButtonTapped")
        present(alertController, animated: true)
    }

    /// Alert that contains a textfield so user can create a shelf and give it a name
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

    /// Textfield used inside alert for making a shelf
    fileprivate var alertTextField: UITextField?

    /// Refresh wheel that's displayed when you drag down on collectionView to refresh library
    let refreshControl = UIRefreshControl()

    /// Fetches the user's library (not including custom shelves right now).
    /// Called either when a user adds a book or when they drag down the collectionView to refresh it
    @objc func fetchLibraryAgain() {
        print("called fetchLibraryAgain")
        UserController.sharedLibraryController.fetchUserLibrary { (_) in
            DispatchQueue.main.async {
                print("refreshed library")
                self.collectionView.reloadData()
                // make sure refreshControl is actually refreshing since this func can be called elsewhere
                if self.refreshControl.isRefreshing {
                    print("WAS refreshing, now ending it")
                    self.refreshControl.endRefreshing()
                }
            }
        }

        // If you want to ALSO refresh the custom shelves you just uncomment this
        // But custom shelves are very weird and unstable so we didn't finish this
//        UserController.sharedLibraryController.fetchCustomShelves { (_) in
//            self.collectionView.reloadData()
//            if self.refreshControl.isRefreshing {
//                self.refreshControl.endRefreshing()
//            }
//        }
    }

    /// Insert a networking method in here used for creating a custom shelf
    private func createNewShelf() {
        print("createNewShelf called, textField text = \(alertTextField?.text ?? "nil")")
        collectionView.reloadData()
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        // add refreshControl to collectionView
        if #available(iOS 10.0, *) {
            // iOS 10 and up TVC/CVC have .refreshControl property
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.tintColor = .tundra
        refreshControl.addTarget(self, action: #selector(fetchLibraryAgain), for: .valueChanged)

        // leaving the "add shelf" button intact for next team, delete is enabled and delete .clear
        addShelfButtonLabel.isEnabled = false
        addShelfButtonLabel.tintColor = .clear

        // Add observer to listen for when to fetch library again
        // (Observers should be in ViewDidLoad so its not added multiple times, this
        // way it will only run once)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchLibraryAgain),
                                               name: .refreshMyLibrary,
                                               object: nil)
    }

    // MARK: UICollectionViewDataSource

    // - The 4 default shelves (My Books, To be read, In progress, and Finished) and the
    // custom shelves the user has created are treated differently on the backend unfortunately.
    // The easiest way to display all the users "shelves" then was to have 2 sections.
    // The first section contains shelves that can be filtered by the readingStatus all UserBooks have
    // and the second sections contains the custom shelves the user has created (currently you can only
    // create custom shelves on the website). Custom shelves store books known as UserBookOnShelf. When you
    // fetch all the books a user has, the UserBooks you get back don't have a shelfId or shelfName property
    // you can use to filter the books into their own sections. Please feel free to ask the developer responsible
    // for our backend why it's set up this way

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        // case 0 means Section 1 (Default Shelves) - contains UserBooks
        // case 1 (or any other than 0) means Section 2 (Custom Shelves) - contains UserBookOnShelf
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

        // if Section 1
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
                cell.shelfNameLabel.text = "Favorites (\(allUserBooks.count))" // Add later
            }
            cell.allUserBooks = allUserBooks
            return cell
        } else if indexPath.section == 1 {
            // if Section 2
            let customShelf = UserController.sharedLibraryController.userShelves[indexPath.item]
            cell.customShelf = customShelf
            cell.shelfNameLabel.text = "\(customShelf.shelfName ?? "Empty Shelf") (\(customShelf.books?.count ?? 0))"
            return cell
        }
        return cell
    }

    // MARK: - Navigation

    // - Each cell in this collectionView represents either an array of an array of UserBooks (Section 1)
    // or a UserShelf (Section 2). When you click on a cell, you need to pass the index of the "shelf" you
    // clicked on to know which "shelf" in the allShelvesArray or userShelves you need to access.
    // * allShelvesArray is an array OF an array of UserBook objects [[UserBook]]
    // * userShelves is an array of UserShelf objects [UserShelf]
    // * A UserShelf object has a .books property that contains UserBookOnShelf objects
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "LibraryToShelf" {
            print("LibraryToShelf")
            if let shelfDetailVC = segue.destination as? ShelfDetailCollectionViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first {

                // pass in the indexPath for allBooksIndex
                if indexPath.section == 0 {
                    shelfDetailVC.allBooksIndex = indexPath.row
                }

                // pass in the indexPath for userShelvesIndex
                if indexPath.section == 1 {
                    shelfDetailVC.userShelvesIndex = indexPath.row
                }

                // Easy way to pass name of shelf user clicked on
                guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
                let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
                shelfDetailVC.title = cell?.shelfNameLabel.text
            }
        }
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
        // used to be 20, 10, 20, 10
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
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
