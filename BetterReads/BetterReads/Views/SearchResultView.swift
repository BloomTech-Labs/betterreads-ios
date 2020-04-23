//
//  SearchResultView.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class SearchResultView: UIView {

    // FIXME: make sure image fills up imageView nicely (aspectFit vs Fill etc..)
    var imageView: UIImageView!

    var titleLabel: UILabel! // var title = uilabel()
    var authorLabel: UILabel!
    var ratingView: UILabel! // FIXME: change back to uiview
    
    var standardMargin: CGFloat = CGFloat(16.0)
    
    private let titleFont = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
    private let authorFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    private let authorTextColor = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0) // Tundra #404040
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubviews()
    }
    
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
                                         multiplier: 0.25).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
                                          multiplier: 1.5).isActive = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 200.0/255.0,
                                            green: 200.0/255.0,
                                            blue: 200.0/255.0,
                                            alpha: 1.0)
        
        // Title Label
        let label = UILabel()
        addSubview(label)
        self.titleLabel = label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                            constant: standardMargin).isActive = true
        
        titleLabel.font = titleFont
        
        // Author Label
        let author = UILabel()
        addSubview(author)
        self.authorLabel = author
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                         constant: standardMargin * 0.25).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                             constant: standardMargin).isActive = true
        
        authorLabel.textColor = authorTextColor
        authorLabel.font = authorFont
        
        // Rating View
        let rating = UILabel()
        addSubview(rating)
        self.ratingView = rating
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true
        // pushed to left by 1 so star point lines up with author name (and so I don't wake up screaming at night)
        ratingView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                            constant: standardMargin - 1.0).isActive = true
        
        ratingView.text = "★★★★★"
        ratingView.textColor = .systemBlue
        ratingView.font = UIFont.systemFont(ofSize: 24.0,
                                            weight: .regular)
    }
}
