//
//  SearchTableViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

// Global Variables for test purposes

//let fakeBooksArray: [Book] = [Book(title: "Harry Potter", author: "JK Rowling", cover: "book.fill", rating: 0.0),
//                              Book(title: "Twilight", author: "Stephenie Meyer", cover: "book.fill", rating: 0.5),
//                              Book(title: "Animal Farm", author: "George Orwell", cover: "book.fill", rating: 1.0),
//                              Book(title: "1984", author: "George Orwell", cover: "book.fill", rating: 1.0),
//                              Book(title: "Metamorphosis", author: "Franz Kafka", cover: "book.fill", rating: 1.3),
//                              Book(title: "50 Shades of Gray", author: "E.L. James", cover: "book.fill", rating: 0.5),
//                              Book(title: "Resident Evil", author: "Capcom", cover: "book.fill", rating: 1.6),
//                              Book(title: "Jumanji", author: "Your mom", cover: "book.fill", rating: 3.4),
//                              Book(title: "The Bible", author: "Jesus", cover: "book.fill", rating: 1.9),
//                              Book(title: "The Maze Runner", author: "James Dashner", cover: "book.fill", rating: 2.1),
//                              Book(title: "Fahrenheit 452", author: "Ray Bradbury", cover: "book.fill", rating: 2.5),
//                              Book(title: "Fahrenheit 453", author: "Ray Bradbury", cover: "book.fill", rating: 3.0),
//                              Book(title: "Fahrenheit 454", author: "Ray Bradbury", cover: "book.fill", rating: 3.3),
//                              Book(title: "Fahrenheit 455", author: "Ray Bradbury", cover: "book.fill", rating: 3.5),
//                              Book(title: "Fahrenheit 456", author: "Ray Bradbury", cover: "book.fill", rating: 3.9),
//                              Book(title: "Fahrenheit 457", author: "Ray Bradbury", cover: "book.fill", rating: 4.2),
//                              Book(title: "Fahrenheit 458", author: "Ray Bradbury", cover: "book.fill", rating: 4.5),
//                              Book(title: "Fahrenheit 459", author: "Ray Bradbury", cover: "book.fill", rating: 4.7),
//                              Book(title: "Fahrenheit 460", author: "Ray Bradbury", cover: "book.fill", rating: 4.5),
//                              Book(title: "Harry Potter 2", author: "JK Rowling", cover: "book.fill", rating: 5.0)]


var myBooksArray = [Book]()
let searchController = SearchController()

class SearchTableViewController: UITableViewController {

    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 212/255, green: 72/255, blue: 8/255, alpha: 1)
        setupToolBar()
    }
    
    private func setupToolBar() {
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Hide",
                                   style: .plain,
                                   target: self,
                                   action: #selector(hideKeyboardAndCancelButton))
        done.tintColor = UIColor(red: 212/255, green: 72/255, blue: 8/255, alpha: 1)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, done]
        bar.sizeToFit()
        searchBar.inputAccessoryView = bar
    }
    
    // FIXME: this should also be called inside searchBarSearchButtonClicked and searchClicked
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
        //return myBooksArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // was 175 when we started
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }

        let book = searchController.searchResultBooks[indexPath.row]
        cell.book = book
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Helpers
    
    private func searchByTerm(searchTerm: String) {
            // searchFuntion() then DispatchQueue.main.async {self.tableView.reloadData()}

//            SearchController.searchByTitle(title: searchTerm) { (response) in
//
//                switch response.result {
//
//                case .success(let data):
//                    print(data)
//                case .failure(let error):
//                    print(error)
//                }
//            }

//            let booksWithSearchTerm = fakeBooksArray.filter {
//                $0.title.lowercased().contains(searchTerm.lowercased()) || $0.author.lowercased().contains(searchTerm.lowercased())
//            }
//            myBooksArray = booksWithSearchTerm
            
        }
    
}

// MARK: - Extensions

extension SearchTableViewController: UISearchBarDelegate {

    // FIXME: - Scroll dismisses keyboard (onScroll?)
    // FIXME: - Should tableview clear when searchbar is empty???
    // Search when typing each letter
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //searchBar.showsCancelButton = true
        guard let searchTerm = searchBar.text else {
            print("Empty searchbar")
            return
        }
        print(searchTerm)
        searchByTerm(searchTerm: searchTerm)
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        //myBooksArray = []; tableView.reloadData() // FIXME: clear table another way?
        searchController.searchResultBooks = []; tableView.reloadData() // FIXME: clear table another way?
        hideKeyboardAndCancelButton()
    }
    
    // dismiss keyboard so user can view all results
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {
            print("Empty searchbar")
            return
        }
        
        print("SearchButtonClicked (tapped return/search)")
        searchController.searchBook(with: searchTerm) { (error) in
            DispatchQueue.main.async {
                print("searchBook called in searchBarSearchButtonClicked")
                print("array count now: \(searchController.searchResultBooks.count)")
                self.tableView.reloadData()
            }
        }
        
        hideKeyboardAndCancelButton()
    }
}
