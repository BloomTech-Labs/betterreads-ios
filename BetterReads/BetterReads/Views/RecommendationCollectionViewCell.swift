//
//  RecommendationCollectionViewCell.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/4/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit
import Nuke

class RecommendationCollectionViewCell: UICollectionViewCell {
    var book: Book? {
        didSet {
            getBookThumbnail()
        }
    }
    @IBOutlet weak var defaultBookImageTitle: UILabel!
    @IBOutlet weak var defaultBookImageAuthor: UILabel!
    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private func getBookThumbnail() {
        defaultBookImageTitle.isHidden = true
        defaultBookImageAuthor.isHidden = true
        bookCoverImageView.layer.cornerRadius = 5
        guard let book = book else {
            activityIndicator.stopAnimating()
            defaultBookImageTitle.isHidden = true
            defaultBookImageAuthor.isHidden = true
            return
        }
        if let smallThumbnailUrl = URL(string: book.smallThumbnail ?? "") {
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "BetterReads-DefaultBookImage"),
                transition: .fadeIn(duration: 0.33)
            )
            Nuke.loadImage(with: smallThumbnailUrl, options: options, into: bookCoverImageView)
        }
        updateViews()
    }
    private func updateViews() {
        if bookCoverImageView.image == UIImage(named: "BetterReads-DefaultBookImage") {
            defaultBookImageTitle.isHidden = false
            defaultBookImageAuthor.isHidden = false
            defaultBookImageTitle.text = book?.title
            defaultBookImageAuthor.text = book?.authors?.first
        }
        defaultBookImageTitle.isHidden = true
        defaultBookImageAuthor.isHidden = true
        activityIndicator.stopAnimating()
        self.setNeedsLayout()
    }
}
