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

    let cornerRadius: CGFloat = 5.0
    let containerForImageView: UIView = {
        var tempContainer = UIView()
        tempContainer.backgroundColor = .clear
        tempContainer.clipsToBounds = false
        tempContainer.translatesAutoresizingMaskIntoConstraints = false
        tempContainer.layer.cornerRadius = 5.0
        tempContainer.layer.shadowColor = UIColor.black.cgColor
        tempContainer.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        tempContainer.layer.shadowRadius = 5.0
        tempContainer.layer.shadowOpacity = 0.9
        return tempContainer
    }()

    /// A UserBook passed in from the user's Default shelves
    var userBook: UserBook? {
        didSet {
            updateViews()
        }
    }

    /// A UserBookOnShelf passed in from the user's Custom shelves
    var userBookOnShelf: UserBookOnShelf? {
        didSet {
            updateViewsForCustomShelf()
        }
    }

    private func updateViews() {
        guard let userBook = userBook else { return }
        shelfNameLabel.text = userBook.title
        guard let thumbnail = userBook.thumbnail else { return }
        SearchController.fetchImage(with: thumbnail) { (image) in
            DispatchQueue.main.async {
                self.shelfImageView.image = image
            }
        }
    }

    private func updateViewsForCustomShelf() {
        guard let userBookOnShelf = userBookOnShelf else { return }
        shelfNameLabel.text = userBookOnShelf.title
        guard let thumbnail = userBookOnShelf.thumbnail else { return }
        SearchController.fetchImage(with: thumbnail) { (image) in
            DispatchQueue.main.async {
                self.shelfImageView.image = image
            }
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

    private func setUpSubviews() {
        // cell size is 192, 249.6 methinks
        // FIXME: change "magic numbers" to be based on cell size instead?
        // Custom View
        let bigView = UIView()
        addSubview(bigView)
        self.customView = bigView
        //customView.backgroundColor = .yellow
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // Container View for Image View
        customView.addSubview(containerForImageView)
        containerForImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerForImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20).isActive = true
        containerForImageView.widthAnchor.constraint(equalTo: widthAnchor,
                                         multiplier: 0.60).isActive = true
        containerForImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                          multiplier: 0.60).isActive = true
        //containerForImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -50).isActive = true

        // Image View (front)
        let tempImageView = UIImageView()
        containerForImageView.addSubview(tempImageView)
        self.shelfImageView = tempImageView
        shelfImageView.translatesAutoresizingMaskIntoConstraints = false
        shelfImageView.topAnchor.constraint(equalTo: containerForImageView.topAnchor).isActive = true
        shelfImageView.leadingAnchor.constraint(equalTo: containerForImageView.leadingAnchor).isActive = true
        shelfImageView.trailingAnchor.constraint(equalTo: containerForImageView.trailingAnchor).isActive = true
        shelfImageView.bottomAnchor.constraint(equalTo: containerForImageView.bottomAnchor).isActive = true
//        //shelfImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10).isActive = true
//        //shelfImageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10).isActive = true
//        //shelfImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10).isActive = true
//        shelfImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
////        shelfImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
////                                           constant: 8).isActive = true
//        shelfImageView.widthAnchor.constraint(equalTo: widthAnchor,
//                                         multiplier: 0.60).isActive = true
//        shelfImageView.heightAnchor.constraint(equalTo: heightAnchor,
//                                          multiplier: 0.60).isActive = true
//        shelfImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -50).isActive = true
        shelfImageView.layer.cornerRadius = 5
        shelfImageView.contentMode = .scaleToFill //fill
        shelfImageView.clipsToBounds = true
        shelfImageView.image = UIImage().chooseDefaultBookImage()

        // Label
        let tempLabel = UILabel()
        addSubview(tempLabel)
        self.shelfNameLabel = tempLabel
        shelfNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shelfNameLabel.topAnchor.constraint(equalTo: containerForImageView.bottomAnchor, constant: 8).isActive = true
//        shelfNameLabel.leadingAnchor.constraint(equalTo: shelfImageView.leadingAnchor).isActive = true
        shelfNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        shelfNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        shelfNameLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8).isActive = true
        shelfNameLabel.text = "Book Name"
        shelfNameLabel.textAlignment = .center
        shelfNameLabel.numberOfLines = 0
        shelfNameLabel.backgroundColor = .white
        shelfNameLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        shelfNameLabel.textColor = .doveGray
        shelfNameLabel.numberOfLines = 0
    }
}
