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

    var allUserBooks: [UserBook]? {
        didSet {
            updateViews()
        }
    }
//    var userBook: UserBook? {
//        didSet {
//            updateViews()
//        }
//    }
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

    private func updateViews() {
        guard let allUserBooks = allUserBooks else { return }

        //shelfNameLabel.text = allUserBooks.first?.title//"My Books"
        guard let firstThumbnail = allUserBooks[0].thumbnail else { return }
        SearchController.fetchImage(with: firstThumbnail) { (image) in
            DispatchQueue.main.async {
                // Add quick fade-in animation (alpha)
                self.shelfImageView.image = image
            }
        }
//        guard let secondThumbnail = allUserBooks[1].thumbnail else { return }
//        SearchController.fetchImage(with: secondThumbnail) { (image) in
//            DispatchQueue.main.async {
//                // Add quick fade-in animation (alpha)
//                self.secondImageView.image = image
//            }
//        }
//        guard let thirdThumbnail = allUserBooks[2].thumbnail else { return }
//        SearchController.fetchImage(with: thirdThumbnail) { (image) in
//            DispatchQueue.main.async {
//                // Add quick fade-in animation (alpha)
//                self.thirdImageView.image = image
//            }
//        }
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
    }
}
