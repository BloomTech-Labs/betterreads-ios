//
//  ShelfDetailCollectionViewCell.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class ShelfDetailCollectionViewCell: UICollectionViewCell {

    var customView: UIView!
    var shelfImageView: UIImageView!
    var shelfNameLabel: UILabel!

    var userBook: UserBook? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let userBook = userBook else { return }
        shelfNameLabel.text = userBook.title
        guard let thumbnail = userBook.thumbnail else { return }
        SearchController.fetchImage(with: thumbnail) { (image) in
            DispatchQueue.main.async {
                // Add quick fade-in animation (alpha)
                self.shelfImageView.image = image
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init with frame")
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init with coder")
        setUpSubviews()
    }

    private func setUpSubviews() {
        print("setupSubviews")
        // cell size is 192, 249.6 methinks
        // FIXME: change "magic numbers" to be based on cell size instead?
        // Custom View
        let bigView = UIView()
        addSubview(bigView)
        self.customView = bigView
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        //customView.backgroundColor = .orange
        customView.layer.cornerRadius = 5
        //customView.clipsToBounds = true
        // Image View (front)
        let tempImageView = UIImageView()
        addSubview(tempImageView)
        self.shelfImageView = tempImageView
        shelfImageView.translatesAutoresizingMaskIntoConstraints = false
        //shelfImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10).isActive = true
        //shelfImageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10).isActive = true
        //shelfImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10).isActive = true
        shelfImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        shelfImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
//                                           constant: 8).isActive = true
        shelfImageView.widthAnchor.constraint(equalTo: widthAnchor,
                                         multiplier: 0.60).isActive = true
        shelfImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                          multiplier: 0.60).isActive = true
        shelfImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -50).isActive = true
        shelfImageView.layer.cornerRadius = 5
        shelfImageView.contentMode = .scaleToFill //fill
        shelfImageView.clipsToBounds = true
        shelfImageView.image = UIImage(named: "twilightBookCover")
        // Label
        let tempLabel = UILabel()
        addSubview(tempLabel)
        self.shelfNameLabel = tempLabel
        shelfNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shelfNameLabel.topAnchor.constraint(equalTo: shelfImageView.bottomAnchor, constant: 0).isActive = true
//        shelfNameLabel.leadingAnchor.constraint(equalTo: shelfImageView.leadingAnchor).isActive = true
        shelfNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        shelfNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        shelfNameLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8).isActive = true
        shelfNameLabel.text = "Twilight Breaking Dawn"
        shelfNameLabel.textAlignment = .center
        shelfNameLabel.numberOfLines = 0
        shelfNameLabel.backgroundColor = .white
    }
}
