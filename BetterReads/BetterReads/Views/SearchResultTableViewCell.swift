//
//  SearchResultTableViewCell.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

// This is just an extra layer of protection since collection view cells can be weird
class SearchResultTableViewCell: UITableViewCell {
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet var mainView: SearchResultView!
    private func updateViews() {
        guard let book = book else { return }
        mainView.book = book
    }
}
