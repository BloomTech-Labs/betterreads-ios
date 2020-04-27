//
//  SearchTableViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

// Global Variables for test purposes

let fakeBooksArray: [Book] = [Book(title: "Harry Potter", author: "JK Rowling", cover: "book.fill", rating: 5.0),
                      Book(title: "Twilight", author: "Stephenie Meyer", cover: "book.fill", rating: 4.0),
                      Book(title: "Animal Farm", author: "George Orwell", cover: "book.fill", rating: 5.0),
                      Book(title: "1984", author: "George Orwell", cover: "book.fill", rating: 5.0),
                      Book(title: "Metamorphosis", author: "Franz Kafka", cover: "book.fill", rating: 5.0),
                      Book(title: "50 Shades of Gray", author: "E.L. James", cover: "book.fill", rating: 2.0),
                      Book(title: "Resident Evil", author: "Capcom", cover: "book.fill", rating: 5.0),
                      Book(title: "Jumanji", author: "Your mom", cover: "book.fill", rating: 4.0),
                      Book(title: "The Bible", author: "Jesus", cover: "book.fill", rating: 5.0),
                      Book(title: "The Maze Runner", author: "James Dashner", cover: "book.fill", rating: 4.0),
                      Book(title: "Fahrenheit 451", author: "Ray Bradbury", cover: "book.fill", rating: 4.5),
                      Book(title: "Harry Potter 2", author: "JK Rowling", cover: "book.fill", rating: 4.0)]

var myBooksArray = [Book]()

class SearchTableViewController: UITableViewController {

    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 11.0/255.0, green: 28.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        setupToolBar()
    }
    
    private func setupToolBar() {
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Hide",
                                   style: .plain,
                                   target: self,
                                   action: #selector(hideKeyboardAndCancelButton))
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
        return myBooksArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // was 175 when we started
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }

        let book = myBooksArray[indexPath.row]
//        cell.mainView.imageView.image = UIImage(systemName: book.cover)
//        cell.mainView.titleLabel.text = book.title
//        cell.mainView.authorLabel.text = book.author
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
                   
    //        SearchController.searchByTitle(title: searchTerm) { (response) in
    //
    //            switch response.result {
    //
    //            case .success(let data):
    //                print(data)
    //            case .failure(let error):
    //                print(error)
    //            }
    //        }
            
            let booksWithSearchTerm = fakeBooksArray.filter {
                $0.title.lowercased().contains(searchTerm.lowercased()) || $0.author.lowercased().contains(searchTerm.lowercased()) 
            }
            myBooksArray = booksWithSearchTerm
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
        myBooksArray = []; tableView.reloadData() // FIXME: clear table another way?
        hideKeyboardAndCancelButton()
    }
    
    // dismiss keyboard so user can view all results
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //print("SearchButtonClicked (tapped return/search)")
        hideKeyboardAndCancelButton()
    }
}
