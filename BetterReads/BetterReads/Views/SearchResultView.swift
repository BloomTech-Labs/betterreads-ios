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
    
    // FIXME: make sure image fills up imageView nicely (aspectFit vs Fill etc..)
    var imageView: UIImageView!

    var titleLabel: UILabel! // var title = uilabel()
    var authorLabel: UILabel!
    var ratingView: UILabel! // FIXME: change back to uiview
    var starsView: UIView! // NEW holds 5 image views inside
    var starsArray: [UIImageView] = [] // NEW holds stars sf icons
    
    var standardMargin: CGFloat = CGFloat(16.0)
    var starSpacing: Int = 4 // change to double/float?
    
    private let titleFont = UIFont(name: "FrankRuhlLibre-Regular", size: 18)
    private let authorFont = UIFont(name: "SourceSansPro-Light", size: 12)
    private let authorTextColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0) // Tundra #404040
    private var lastThumbnailImage: String?
    
    // MARK: - View LifeCycle
    
    var book: Book? {
        didSet {
            updateViews()
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
    
    private func updateViews() {
        guard let book = book else { return }
                
        titleLabel.text = book.title
        authorLabel.text = book.authors?.first
        updateStarRating(value: book.averageRating ?? 0.0) // book.rating

        // FIXME: use cache to improve this?
        guard let thumbnail = book.thumbnail else { return }
        print("updateViews, lastImage = \(lastThumbnailImage ?? "nil thumbnail")")
        if lastThumbnailImage != thumbnail {
            print("no image in imageView, fetching an image")
            SearchController.fetchImage(with: thumbnail) { (image) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.lastThumbnailImage = thumbnail
                }
            }
        }
        
    }
    
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
        
    private func setUpSubviews() {
        
        
        // Image View
        let imageView = UIImageView()
        addSubview(imageView)
        self.imageView = imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // FIXME: use top and bottom anchors instead to always give 8ish points from top and bottom?
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
        titleLabel.numberOfLines = 0
        
        // Author Label
        let author = UILabel()
        addSubview(author)
        self.authorLabel = author
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                         constant: standardMargin * 0).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                             constant: standardMargin).isActive = true
        
        authorLabel.textColor = .tundra
        authorLabel.font = authorFont
                
        // stars view (5 image view inside)
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
        
        // FIXME: Add Button? (NOT DONE, this needs to be assigned to a property )
                
        // Stars Array (goes inside starsView)
        // FIXME: change Int to double/float ?
        let starSize = Int(self.frame.size.height * CGFloat(0.10)) // FIXME: should be based on cell size?
        for i in 1...5 {
            let star = UIImageView()
            starsView.addSubview(star)
            starsArray.append(star)
            star.tag = i
            star.frame = CGRect(x: ((starSize + starSpacing) * (i - 1)),
                                y: 0,
                                width: starSize,
                                height: starSize)
            star.image = UIImage(named: "Stars_Chunky-AltoGray")
            //star.tintColor = UIColor(red: 11.0/255.0, green: 28.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        }
    }
}
