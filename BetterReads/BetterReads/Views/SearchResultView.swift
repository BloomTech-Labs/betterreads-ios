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
    
    private let titleFont = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
    private let authorFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    private let authorTextColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0) // Tundra #404040
    
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
        authorLabel.text = book.author + " \(book.rating)"
        imageView.image = UIImage(systemName: book.cover)
        updateStarRating(value: book.rating)
    }
    
    // FIXME: change else if back to half star when we get gray half star icons
    private func updateStarRating(value: Double) {
        var chunk = value
        for star in starsArray {
            if chunk >= 0.66 && chunk <= 5.0 {
                star.image = UIImage(named: "Stars_Chunky-DoveGray")
            } else if chunk >= 0.33 && chunk < 0.66 {
                star.image = UIImage(named: "Stars_Chunky-DoveGray")
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
        // FIXME: (later) change imageView scale/size based on what image is passed in? cell size?
        imageView.contentMode = .scaleAspectFit
        
        // Catalina Blue
        imageView.backgroundColor = UIColor(red: 200.0/255.0,
                                            green: 200.0/255.0,
                                            blue: 200.0/255.0,
                                            alpha: 1.0)
        imageView.tintColor = UIColor(red: 11.0/255.0, green: 28.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        
        // Title Label
        let label = UILabel()
        addSubview(label)
        self.titleLabel = label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                            constant: standardMargin).isActive = true
        
        titleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 20)//titleFont
        titleLabel.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
        
        // Author Label
        let author = UILabel()
        addSubview(author)
        self.authorLabel = author
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                         constant: standardMargin * 0).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                             constant: standardMargin).isActive = true
        
        authorLabel.textColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)//authorTextColor
        authorLabel.font = UIFont(name: "FrankRuhlLibre-Regular", size: 16) //authorFont
                
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
        let starSize = Int(self.frame.size.height * CGFloat(0.15)) // FIXME: should be based on cell size?
        for i in 1...5 {
            let star = UIImageView()
            starsView.addSubview(star)
            starsArray.append(star)
            print("starsArray.count = \(starsArray.count)")
            star.tag = i
            star.frame = CGRect(x: (starSize * (i - 1)),
                                y: 0,
                                width: starSize,
                                height: starSize)
            star.image = UIImage(named: "Stars_Chunky-AltoGray")
            star.tintColor = UIColor(red: 11.0/255.0, green: 28.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        }
    }
}
