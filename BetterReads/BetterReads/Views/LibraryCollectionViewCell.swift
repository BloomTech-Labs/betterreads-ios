//
//  LibraryCollectionViewCell.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    /// Acts as a "container" for other views, and is pinned to all side of cell it's in
    var customView: UIView!

    /// Front book in stack
    var firstImageView: UIImageView!

    /// Second book in stack
    var secondImageView: UIImageView!

    /// Gray filter over second book in stack
    var secondBGView: UIView!

    /// Third book in stack
    var thirdImageView: UIImageView!

    /// Gray filter over third book in stack
    var thirdBGView: UIView!

    /// Label that displays the name of the shelf
    var shelfNameLabel: UILabel!

    /// Array of UIImageViews that represent of 3 cover images of the shelf it displays
    var coversArray = [UIImageView]()

    /// Array of UserBooks to fill in the 3 cover images (if displaying a default shelf)
    var allUserBooks: [UserBook]? {
        didSet {
            updateViews()
        }
    }

    /// A UserShelf that contains an array of UserBookOnShelf (if displaying a custom shelf)
    var customShelf: UserShelf? {
        didSet {
            fillCoversForCustomShelf()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }

    /// Fills in the 3 cover images of the cell if it's passed in an array of UserBooks
    /// (There's currently a bug where if you add a book that has a default image, it will
    /// give some book shelves incorrect shelf covers, but the books inside are correct)
    private func fillUpCoverImages() {
        guard let allUserBooks = allUserBooks else { return }

        // 3 or more books
        if allUserBooks.count >= 3 {
            for index in 0..<3 {
                guard let thumbnail = allUserBooks[index].thumbnail else { return }
                SearchController.fetchImage(with: thumbnail) { (image) in
                    DispatchQueue.main.async {
                        self.coversArray[index].image = image
                    }
                }
            }
        }

        // 2 books only
        if allUserBooks.count == 2 {
            for index in 0..<2 {
                guard let thumbnail = allUserBooks[index].thumbnail else { return }
                SearchController.fetchImage(with: thumbnail) { (image) in
                    DispatchQueue.main.async {
                        self.coversArray[index].image = image
                    }
                }
            }
            coversArray[2].image = UIImage(named: "BetterReads-DefaultBookImage")
        }

        // 1 book only
        if allUserBooks.count == 1 {
            guard let thumbnail = allUserBooks.first?.thumbnail else { return }
            SearchController.fetchImage(with: thumbnail) { (image) in
                DispatchQueue.main.async {
                    self.coversArray.first?.image = image
                }
            }
            coversArray[1].image = UIImage(named: "BetterReads-DefaultBookImage")
            coversArray[2].image = UIImage(named: "BetterReads-DefaultBookImage")
        }

        // Empty Shelf
        if allUserBooks.count == 0 {
            for book in coversArray {
                book.image = UIImage(named: "BetterReads-DefaultBookImage")
            }
        }
    }

    /// Used if a UserShelf is passed in instead of an array of UserBook
    private func fillCoversForCustomShelf() {
        guard let customShelf = customShelf,
            let customShelfBooks = customShelf.books else { return }

        // 3 or more books
        if customShelfBooks.count >= 3 {
            for index in 0..<3 {
                guard let thumbnail = customShelfBooks[index].thumbnail else { return }
                SearchController.fetchImage(with: thumbnail) { (image) in
                    DispatchQueue.main.async {
                        self.coversArray[index].image = image
                    }
                }
            }
        }

        // 2 books only
        if customShelfBooks.count == 2 {
            for index in 0..<2 {
                guard let thumbnail = customShelfBooks[index].thumbnail else { return }
                SearchController.fetchImage(with: thumbnail) { (image) in
                    DispatchQueue.main.async {
                        self.coversArray[index].image = image
                    }
                }
            }
            coversArray[2].image = UIImage(named: "BetterReads-DefaultBookImage")
        }

        // 1 book only
        if customShelfBooks.count == 1 {
            guard let thumbnail = customShelfBooks.first?.thumbnail else { return }
            SearchController.fetchImage(with: thumbnail) { (image) in
                DispatchQueue.main.async {
                    self.coversArray.first?.image = image
                }
            }
            coversArray[1].image = UIImage(named: "BetterReads-DefaultBookImage")
            coversArray[2].image = UIImage(named: "BetterReads-DefaultBookImage")
        }

        // Empty Shelf
        if customShelfBooks.count == 0 {
            for book in coversArray {
                book.image = UIImage(named: "BetterReads-DefaultBookImage")
            }
        }
    }

    private func updateViews() {
        fillUpCoverImages()
    }

    // These chunks can be put into their own functions and then just be called in order
    private func setUpSubviews() {

        // Custom View
        let bigView = UIView()
        addSubview(bigView)
        self.customView = bigView
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // Third Image Gray Underlay
        let thirdBGView2 = UIView()
        addSubview(thirdBGView2)
        self.thirdBGView = thirdBGView2
        thirdBGView.translatesAutoresizingMaskIntoConstraints = false
        thirdBGView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 30).isActive = true
        thirdBGView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10).isActive = true
        thirdBGView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10).isActive = true
        thirdBGView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -70).isActive = true
        thirdBGView.backgroundColor = .doveGray
        thirdBGView.alpha = 1
        thirdBGView.layer.cornerRadius = 5

        // Third Image View (Back)
        let tempImageView3 = UIImageView()
        addSubview(tempImageView3)
        self.thirdImageView = tempImageView3
        thirdImageView.translatesAutoresizingMaskIntoConstraints = false
        thirdImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 30).isActive = true
        thirdImageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10).isActive = true
        thirdImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10).isActive = true
        thirdImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -70).isActive = true
        thirdImageView.layer.cornerRadius = 5
        thirdImageView.contentMode = .scaleToFill
        thirdImageView.clipsToBounds = true
        thirdImageView.image = UIImage(named: "BetterReads-DefaultBookImage")
        thirdImageView.alpha = 0.30

        // Second Image Gray Underlay
        let secondBGView1 = UIView()
        addSubview(secondBGView1)
        self.secondBGView = secondBGView1
        secondBGView.translatesAutoresizingMaskIntoConstraints = false
        secondBGView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20).isActive = true
        secondBGView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10).isActive = true
        secondBGView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -30).isActive = true
        secondBGView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -60).isActive = true
        secondBGView.backgroundColor = .doveGray
        secondBGView.alpha = 1
        secondBGView.layer.cornerRadius = 5

        // Second Image View (Middle)
        let tempImageView2 = UIImageView()
        addSubview(tempImageView2)
        self.secondImageView = tempImageView2
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20).isActive = true
        secondImageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10).isActive = true
        secondImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -30).isActive = true
        secondImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -60).isActive = true
        secondImageView.layer.cornerRadius = 5
        secondImageView.contentMode = .scaleToFill
        secondImageView.clipsToBounds = true
        secondImageView.image = UIImage(named: "BetterReads-DefaultBookImage")
        secondImageView.alpha = 0.60

        // First Image View (front)
        let tempImageView1 = UIImageView()
        addSubview(tempImageView1)
        self.firstImageView = tempImageView1
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10).isActive = true
        firstImageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10).isActive = true
        firstImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -50).isActive = true
        firstImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -50).isActive = true
        firstImageView.layer.cornerRadius = 5
        firstImageView.contentMode = .scaleToFill
        firstImageView.clipsToBounds = true
        firstImageView.image = UIImage(named: "BetterReads-DefaultBookImage")

        // Label
        let tempLabel = UILabel()
        addSubview(tempLabel)
        self.shelfNameLabel = tempLabel
        shelfNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shelfNameLabel.topAnchor.constraint(equalTo: firstImageView.bottomAnchor, constant: 0).isActive = true
        shelfNameLabel.leadingAnchor.constraint(equalTo: firstImageView.leadingAnchor).isActive = true
        shelfNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        shelfNameLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8).isActive = true
        shelfNameLabel.text = "Shelf Name"
        shelfNameLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        shelfNameLabel.textColor = .doveGray
        shelfNameLabel.textAlignment = .center
        shelfNameLabel.numberOfLines = 0
        shelfNameLabel.backgroundColor = .white

        coversArray.append(firstImageView)
        coversArray.append(secondImageView)
        coversArray.append(thirdImageView)
    }
}
