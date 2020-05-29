//
//  StarRatingStackView.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/11/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation
import UIKit

class StarRatingStackView: UIStackView {

    // MARK: - Properties

    /// Holds 5 star images inside
    var starsView: UIView!

    /// Array of star images
    var starsArray = [UIImageView]()

    /// How many stars should be filled in
    var ratingValue: Double? {
        didSet {
            updateStarRating()
        }
    }

    /// Size of each star
    var starSize: Double = 20.0

    // MARK: - View Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init with frame")
        setupSubviews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        print("init with coder")
        setupSubviews()
    }

    /// Sets up stackView and stars
    private func setupSubviews() {

        distribution = .fillEqually
        for integer in 1...5 {
            let star = UIImageView()
            star.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(star)
            starsArray.append(star)
            star.tag = integer
            star.contentMode = .scaleToFill
            star.frame = CGRect(x: 0,
                                y: 0,
                                width: starSize,
                                height: starSize)
            star.image = UIImage(named: "Stars_Chunky-AltoGray")
        }
        updateStarRating()
    }

    // MARK: - Methods

    /// Fills up each star to match the rating it represents
    private func updateStarRating() {
        let value = ratingValue ?? 0
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
}
