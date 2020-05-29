//
//  ShelfDetailCollectionViewCell.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//
import UIKit
class ShelfDetailCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    /// Acts as "container" for views inside it, this is pinned to all sides of the cell it's in
    var customView: UIView!

    /// Displays the book's cover image
    var shelfImageView: UIImageView!

    /// Displays the book's title (can be up to 3 lines long)
    var shelfNameLabel: UILabel!

    /// Dont think this is used anywhere in here, leaving it here just in case though
    let cornerRadius: CGFloat = 5.0

    /// Container for image so it can have a corner radius AND a shadow
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

    // MARK: - View Life Cycle

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
        // Custom View
        let bigView = UIView()
        addSubview(bigView)
        self.customView = bigView
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // Container View for Image View
        customView.addSubview(containerForImageView)
        containerForImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerForImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10).isActive = true
        containerForImageView.widthAnchor.constraint(equalTo: widthAnchor,
                                         multiplier: 0.64).isActive = true
        containerForImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                          multiplier: 0.69).isActive = true
        //containerForImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -50).isActive = true

        // The shadow effect is not very effecient currently, so giving it a shadowPath would help
        // This commented out code WOULD work if this view was made with a frame
        // but it wasn't so maybe later see if you can implement something like this
//        tempContainer.layer.shadowPath = UIBezierPath(roundedRect: containerForImageView.bounds,
//                                                      cornerRadius: cornerRadius).cgPath

        // Image View
        let tempImageView = UIImageView()
        containerForImageView.addSubview(tempImageView)
        self.shelfImageView = tempImageView
        shelfImageView.translatesAutoresizingMaskIntoConstraints = false
        shelfImageView.topAnchor.constraint(equalTo: containerForImageView.topAnchor).isActive = true
        shelfImageView.leadingAnchor.constraint(equalTo: containerForImageView.leadingAnchor).isActive = true
        shelfImageView.trailingAnchor.constraint(equalTo: containerForImageView.trailingAnchor).isActive = true
        shelfImageView.bottomAnchor.constraint(equalTo: containerForImageView.bottomAnchor).isActive = true
        shelfImageView.layer.cornerRadius = 5
        shelfImageView.contentMode = .scaleToFill
        shelfImageView.clipsToBounds = true
        shelfImageView.image = UIImage().chooseDefaultBookImage()

        // Label
        let tempLabel = UILabel()
        addSubview(tempLabel)
        self.shelfNameLabel = tempLabel
        shelfNameLabel.translatesAutoresizingMaskIntoConstraints = false
        shelfNameLabel.topAnchor.constraint(equalTo: containerForImageView.bottomAnchor, constant: 8).isActive = true
        //shelfNameLabel.leadingAnchor.constraint(equalTo: shelfImageView.leadingAnchor).isActive = true
        shelfNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        shelfNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        //shelfNameLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8).isActive = true
        shelfNameLabel.text = "Book Name"
        shelfNameLabel.textAlignment = .center
        shelfNameLabel.numberOfLines = 3
        shelfNameLabel.backgroundColor = .clear
        shelfNameLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        shelfNameLabel.textColor = .doveGray
    }
}
