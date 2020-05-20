//
//  LibraryCollectionViewCell.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {

    var customView: UIView!
    var shelfImageView: UIImageView!
    var secondImageView: UIImageView!
    var thirdImageView: UIImageView!
    var shelfNameLabel: UILabel!

    /// Array of ImageViews that represent of 3 cover images of the shelf it displays
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
        print("init with frame")
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init with coder")
        setUpSubviews()
    }

    /// Fills in the 3 cover images of the cell if it's passed in an array of UserBooks
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
        }

        // 1 book only
        if allUserBooks.count == 1 {
            guard let thumbnail = allUserBooks.first?.thumbnail else { return }
            SearchController.fetchImage(with: thumbnail) { (image) in
                DispatchQueue.main.async {
                    self.coversArray.first?.image = image
                }
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
        }

        // 1 book only
        if customShelfBooks.count == 1 {
            guard let thumbnail = customShelfBooks.first?.thumbnail else { return }
            SearchController.fetchImage(with: thumbnail) { (image) in
                DispatchQueue.main.async {
                    self.coversArray.first?.image = image
                }
            }
        }
    }
    
    private func updateViews() {
        fillUpCoverImages()
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
        thirdImageView.alpha = 1

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
        secondImageView.alpha = 1

        // Image View (front)
        let tempImageView = UIImageView()
        addSubview(tempImageView)
        self.shelfImageView = tempImageView
        shelfImageView.translatesAutoresizingMaskIntoConstraints = false
        shelfImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10).isActive = true
        shelfImageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10).isActive = true
        shelfImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -50).isActive = true
        shelfImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -50).isActive = true
        shelfImageView.layer.cornerRadius = 5
        shelfImageView.contentMode = .scaleToFill
        shelfImageView.clipsToBounds = true
        shelfImageView.image = UIImage(named: "BetterReads-DefaultBookImage")

        // Label
        let tempLabel = UILabel()
        addSubview(tempLabel)
        self.shelfNameLabel = tempLabel
        shelfNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shelfNameLabel.topAnchor.constraint(equalTo: shelfImageView.bottomAnchor, constant: 0).isActive = true
        shelfNameLabel.leadingAnchor.constraint(equalTo: shelfImageView.leadingAnchor).isActive = true
        shelfNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        shelfNameLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8).isActive = true
        shelfNameLabel.text = "Shelf Name"
        shelfNameLabel.textAlignment = .center
        shelfNameLabel.numberOfLines = 0
        shelfNameLabel.backgroundColor = .white
        
        coversArray.append(shelfImageView)
        coversArray.append(secondImageView)
        coversArray.append(thirdImageView)
    }
}
