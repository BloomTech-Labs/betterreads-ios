//
//  SearchResultView.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class SearchResultView: UIView {

    // MARK: - Properties

    /// Displays book cover image
    var imageView: UIImageView!

    /// Displays title of book
    var titleLabel: UILabel!

    /// Displays author of book
    var authorLabel: UILabel!

    /// Not sure if this is even used anymore, too scared to remove right now
    var ratingView: UILabel!

    /// View that holds 5 star UIImageViews made below
    var starsView: UIView!

    /// Array that holds star UIImageViews to loop through all later
    var starsArray: [UIImageView] = []

    /// Used for padding
    var standardMargin: CGFloat = CGFloat(16.0)

    /// Spacing between each star in the starsView
    var starSpacing: Int = 4

    private let titleFont = UIFont(name: "FrankRuhlLibre-Regular", size: 20)
    private let authorFont = UIFont(name: "SourceSansPro-Light", size: 16)
    private let authorTextColor = UIColor.tundra

    /// Stores last image the cell had *(might have to delete this if you choose to implement image caches)
    private var lastThumbnailImage: String?

    /// Book passed in from SearchTableViewController
    var book: Book? {
        didSet {
            updateViews()
        }
    }

    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }

    private func updateViews() {
        guard let book = book else { return }
        titleLabel.text = book.title
        authorLabel.text = book.authors?.first
        updateStarRating(value: book.averageRating ?? 0.0)
        guard let thumbnail = book.thumbnail else {
            imageView.image = UIImage().chooseDefaultBookImage()
            return
        }

        // there used to be a bug where images would flash, and this "fixed" it
        // use cache to improve this later (this might not be needed anymore)
        if lastThumbnailImage != thumbnail {
            SearchController.fetchImage(with: thumbnail) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.lastThumbnailImage = thumbnail
                }
            }
        }
    }

    /// Takes in double and fills up the stars in rating view
    private func updateStarRating(value: Double) {
        var chunk = value
        for star in starsArray {
            if chunk >= 0.66 && chunk <= 5.0 {
                star.image = UIImage(named: "Stars_Chunky-DoveGray")
            } else if chunk >= 0.33 && chunk < 0.66 {
                star.image = UIImage(named: "Stars_Chunky-AltoGray-LeftHalf")
            } else {
                star.image = UIImage(named: "Stars_Chunky-AltoGray")
            }
            chunk = value - Double(star.tag)
        }
    }

    // This can be split up into smaller functions called in order
    private func setUpSubviews() {

        // Image View
        let imageView = UIImageView()
        addSubview(imageView)
        self.imageView = imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: standardMargin).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor,
                                         multiplier: 0.20).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor,
                                          multiplier: 0.75).isActive = true
        //imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3 / 4).isActive = true
        // mult for height used to be 1.5 of imageView.widthAnchor // widthAnchor used to be 0.25
        imageView.contentMode = .scaleToFill // used to be .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.tintColor = .trinidadOrange

        // Title Label
        let label = UILabel()
        addSubview(label)
        self.titleLabel = label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                            constant: standardMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin).isActive = true
        titleLabel.font = titleFont
        titleLabel.textColor = .tundra
        titleLabel.numberOfLines = 2

        // Author Label
        let author = UILabel()
        addSubview(author)
        self.authorLabel = author
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                         constant: standardMargin * 0).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                             constant: standardMargin).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin).isActive = true
        authorLabel.numberOfLines = 2
        authorLabel.textColor = .tundra
        authorLabel.font = authorFont

        // Stars View (5 image view inside)
        let view = UIView()
        addSubview(view)
        self.starsView = view
        starsView.translatesAutoresizingMaskIntoConstraints = false
        starsView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor,
                                       constant: standardMargin * 0.15).isActive = true
        // pushed to left by 1 so star point lines up with author name (and so I don't wake up screaming at night)
        starsView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                           constant: standardMargin - 1.0).isActive = true
        starsView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor).isActive = true
        starsView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true

        // Stars Array (goes inside starsView)
        let starSize = Int(self.frame.size.height * CGFloat(0.10))
        for integer in 1...5 {
            let star = UIImageView()
            starsView.addSubview(star)
            starsArray.append(star)
            star.tag = integer
            star.frame = CGRect(x: ((starSize + starSpacing) * (integer - 1)),
                                y: 0,
                                width: starSize,
                                height: starSize)
            star.image = UIImage(named: "Stars_Chunky-AltoGray")
        }
    }
}
