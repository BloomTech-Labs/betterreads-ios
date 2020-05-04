//
//  RecommendationCollectionViewCell.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/4/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {
    
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var bookCoverImageView: UIImageView!
    
    private func updateViews() {
        guard let book = book,
            let imageName = book.smallThumbnail else { return }
        
        bookCoverImageView.image = UIImage(named: imageName)
    }
}
