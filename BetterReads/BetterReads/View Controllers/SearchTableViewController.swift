//
//  SearchTableViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

var myBooksArray = [Book]()

class SearchTableViewController: UITableViewController {

    // MARK: - Properties

    /// Contains the book results you get back from it's search method
    let searchController = SearchController()

    /// Loading indicator displayed while searching for a book
    let spinner = UIActivityIndicatorView(style: .large)

    @IBOutlet var searchBar: UISearchBar!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.tintColor = .trinidadOrange
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundView?.isHidden = true
        tableView.backgroundView = spinner
        spinner.backgroundColor = .altoGray
        spinner.color = .tundra
        // Back button title for next screen
        let backItem = UIBarButtonItem()
        backItem.title = "" // now only the arrow is showing
        navigationItem.backBarButtonItem = backItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // if the view appears and there's no text, auto "click" into searchbar
        if searchBar.text == "" {
            searchBar.becomeFirstResponder()
        }
    }

    // MARK: - Methods

    @objc private func hideKeyboardAndCancelButton() {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.searchResultBooks.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell",
                                                       for: indexPath) as? SearchResultTableViewCell
            else { return UITableViewCell() }
        let book = searchController.searchResultBooks[indexPath.row]
        cell.book = book
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToDetail" {
            print("SearchToDetail")
            if let detailVC = segue.destination as? BookDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.book = searchController.searchResultBooks[indexPath.row]
                let cell = tableView.cellForRow(at: indexPath) as? SearchResultTableViewCell
                detailVC.bookCoverImageView.image = cell?.mainView.imageView.image
                detailVC.blurredBackgroundView.image = cell?.mainView.imageView.image
            }
        }
    }
}

// MARK: - Extensions

extension SearchTableViewController: UISearchBarDelegate {

    // Hides "Cancel" button when user clicks inside searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    // clears searchBar text, clears tableView, and hides keyboard/cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchController.searchResultBooks = []
        tableView.reloadData()
        hideKeyboardAndCancelButton()
    }

    // Searches for book when user taps "return/enter" on keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        spinner.startAnimating()
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {
            print("Empty searchbar")
            return
        }

        print("SearchButtonClicked (tapped return/search)")
        searchController.searchBook(with: searchTerm) { (error) in
            DispatchQueue.main.async {
                _ = error
                print("searchBook called in searchBarSearchButtonClicked")
                print("array count now: \(self.searchController.searchResultBooks.count)")
                self.tableView.reloadData()
                self.spinner.stopAnimating()
            }
        }
        hideKeyboardAndCancelButton()
    }
}
