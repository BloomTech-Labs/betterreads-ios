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
        bookCoverImageView.layer.cornerRadius = 5
        guard let book = book else {
            activityIndicator.stopAnimating()
            return
        }
        if let thumbnail = book.thumbnail?.replacingOccurrences(of: "&edge=curl", with: ""),
            let thumbnailUrl = URL(string: thumbnail) {
            let options = ImageLoadingOptions(
                transition: .fadeIn(duration: 0.33)
            )
            Nuke.loadImage(with: thumbnailUrl, options: options, into: bookCoverImageView)
            return updateViews()
        } else {
            defaultBookImageTitle.text = """
                                        \u{201C}\(book.title ?? "Title not available")\u{201D}
                                        """
            defaultBookImageAuthor.text = "by \(book.authors?.first ?? "Unknown")"
            defaultBookImageTitle.isHidden = false
            defaultBookImageAuthor.isHidden = false
            return updateViews()
        }
    }
    private func updateViews() {
        activityIndicator.stopAnimating()
        self.setNeedsLayout()
    }
}
