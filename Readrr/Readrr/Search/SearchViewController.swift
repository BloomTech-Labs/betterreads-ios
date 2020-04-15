//
//  SearchViewController.swift
//  Readrr
//
//  Created by Alexander Supe on 4/14/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    static var searchTerm = "" // global
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar?.delegate = self
        searchBar?.placeholder = "Search for book by title or author"
    }

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
            $0.lowercased().contains(searchTerm.lowercased())
        }
        myBooksArray = booksWithSearchTerm
    }
    
}

extension SearchViewController: UISearchBarDelegate {

    // Search when typing each letter
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //searchBar.showsCancelButton = true
        guard let searchTerm = searchBar.text else {
            print("Empty searchbar")
            return
        }
        print(searchTerm)
        searchByTerm(searchTerm: searchTerm)
        // 2
        NotificationCenter.default.post(name: .updateEmbeddedTVC, object: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}
