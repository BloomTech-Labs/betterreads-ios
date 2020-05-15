//
//  SearchResultTableViewCell.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

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
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
}
