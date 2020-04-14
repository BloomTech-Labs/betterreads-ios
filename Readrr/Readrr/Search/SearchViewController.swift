//
//  SearchViewController.swift
//  Readrr
//
//  Created by Alexander Supe on 4/14/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    static var searchTerm = "" // global
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar?.delegate = self
        searchBar?.placeholder = "Search for book by title or author"
    }

}

extension SearchViewController: UISearchBarDelegate {

    // Search when
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard let searchTerm = searchBar.text else {
            print("Empty searchbar")
            return
        }
        print(searchTerm)
        // searchFuntion() then DispatchQueue.main.async {self.tableView.reloadData()}
        
        let booksWithSearchTerm = fakeBooksArray.filter {
            $0.lowercased().contains(searchTerm.lowercased())
        }
        myBooksArray = booksWithSearchTerm
        
        // 2
        NotificationCenter.default.post(name: .updateEmbeddedTVC, object: self)
    }
}

// 1
extension NSNotification.Name {
    static let updateEmbeddedTVC = NSNotification.Name("updateEmbeddedTVC")
}
