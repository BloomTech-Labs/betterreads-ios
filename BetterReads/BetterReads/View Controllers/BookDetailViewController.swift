//
//  BookDetailViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    // FIXME: make these properties with an ! at the end???
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        //v.backgroundColor = .cyan
        return v
    }()
    
    let blurredBackgroundView: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.image = UIImage(named: "twilightBookCover")
        bg.contentMode = .scaleToFill
        return bg
    }()
    
    let bookCoverImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.backgroundColor = .yellow
        iv.image = UIImage(named: "twilightBookCover")
        iv.contentMode = .scaleAspectFill // used to be .scaleToFit
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    // FIXME: make this numberOfLines = 0 for long titles?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Twilight Breaking Dawn"
        label.font = UIFont(name: "FrankRuhlLibre-Regular", size: 24)
//        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // FIXME: make this numberOfLines = 0 for long authors?
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "by Stephenie Meyer"
        label.font = UIFont(name: "SourceSansPro-Light", size: 16)
//        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingStackView: StarRatingStackView = {
        let rv = StarRatingStackView()
        rv.axis = .horizontal
        //rv.distribution = .fillEqually
        rv.spacing = 4
        rv.ratingValue = 5.0
        rv.translatesAutoresizingMaskIntoConstraints = false
        return rv
    }()
            
    // FIXME: Average Rating label (3.12 avg rating / or No ratings)
    // Average Rating Label
    let averageRatingLabel: UILabel = {
        let al = UILabel()
        al.translatesAutoresizingMaskIntoConstraints = false
        al.text = "4.7 average rating"
        al.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        al.textAlignment = .center
        return al
    }()
    
    // FIXME: make button have default "pressing" animation that comes with storyboard buttons
    let addButton: UIButton = {
        let tempButton = UIButton(type: .custom) // .system
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.backgroundColor = .trinidadOrange
        tempButton.tintColor = .white
        tempButton.setTitle("Add Book", for: .normal)
        tempButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        tempButton.layer.cornerRadius = 10
        return tempButton
    }()
        
    let lineBreak: UIView = {
        let lb = UIView()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.layer.cornerRadius = 5
        lb.backgroundColor = .altoGray
        return lb
    }()
    
    let bottomStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.spacing = 4
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let publisherLabel: UILabel = {
        let pl = UILabel()
        pl.text = "Publisher: Little, Brown Books for Young Readers, 2008"
        pl.font = UIFont(name: "SourceSansPro-Light", size: 16)
        pl.numberOfLines = 0
        return pl
    }()
    
    let isbnLabel: UILabel = {
        let il = UILabel()
        il.text = "ISBN: 9780316032834"
        il.font = UIFont(name: "SourceSansPro-Light", size: 16)
        return il
    }()
    
    let lengthLabel: UILabel = {
        let ll = UILabel()
        ll.text = "Length: 768 pages"
        ll.font = UIFont(name: "SourceSansPro-Light", size: 16)
        return ll
    }()
    
    /// This is a label because it's height can be easily based on it's content (text) inside so scroll view changes accordingly
    let descriptionLabel: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .magenta
        tv.text = "With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. Here is the series finale."
        tv.numberOfLines = 0
        return tv
    }()
    
    let dummyView: UILabel = {
        let dv = UILabel()
        dv.translatesAutoresizingMaskIntoConstraints = false
        dv.layer.cornerRadius = 5
        dv.backgroundColor = .tundra
        dv.textColor = .white
        dv.textAlignment = .center
        dv.text = "Fiction"
        dv.clipsToBounds = true
        return dv
    }()
    
    let contentView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        //cv.backgroundColor = .yellow
        return cv
    }()
    
    // FIXME: add sound effect for add book to library? (similar to App store purchase success)?
    @objc func showAlert() {
        print("add button tapped")
        addButton.performFlare()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // To change status bar text to white
        navigationController?.navigationBar.barStyle = .black
    }
    
    // To change status bar text back to black
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    // FIXME: THIS NEEDS TO RUN BEFORE THIS VIEW LOADS. USE NOTIFICATION TO PASS TOP BAR HEIGTH BEFOREHAND
    private func statusAndNavigationBarHeight() -> CGFloat {
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        print("nav height = \(navHeight)")
        print("status height = \(statusHeight)")
        return navHeight + statusHeight
    }
    
    private func setupSubviews() {
        // Scroll View
        // add the scroll view to self.view
        title = ""
        self.view.addSubview(scrollView)
        // constrain the scroll view to 8-pts on each side
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        // Holy fuck this solved my issue
        scrollView.contentInsetAdjustmentBehavior = .never
        // quick fix to keep from scrolling too high
        scrollView.bounces = false
        
        
        // Content View
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        
        // Blurred Background Image View
        contentView.addSubview(blurredBackgroundView)
        blurredBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        blurredBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blurredBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        blurredBackgroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        // FIXME: Change tint/text color to white and remove back button text
        // Transparent Nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
            // blur effect
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        blurView.frame = blurredBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // add blurView over blurredBackgroundView
        blurredBackgroundView.addSubview(blurView)
        
        // Book Image View
        contentView.addSubview(bookCoverImageView) // contentView.topAnchor, constant: 100
        bookCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100).isActive = true
        //bookCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        bookCoverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        bookCoverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalTo: bookCoverImageView.widthAnchor, multiplier: 1.5).isActive = true

        // Title Label
        // add labelOne to the scroll view
        contentView.addSubview(titleLabel)
        // constrain labelOne to left & top with 16-pts padding
        // this also defines the left & top of the scroll content
        //titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor, constant: 16).isActive = true
        //titleLabel.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        // Author Label
        // add authorLabel to the scroll view
        contentView.addSubview(authorLabel)
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        //authorLabel.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
        authorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        //authorLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true

        // Rating Stack View
        contentView.addSubview(ratingStackView)
        ratingStackView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8).isActive = true
        ratingStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        ratingStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        ratingStackView.heightAnchor.constraint(equalTo: ratingStackView.widthAnchor, multiplier: 0.2).isActive = true
        
        // Average Rating Label
        contentView.addSubview(averageRatingLabel)
        averageRatingLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4).isActive = true
        averageRatingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        //ratingView.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
        //averageRatingLabel.widthAnchor.constraint(equalTo: authorLabel.widthAnchor).isActive = true
        //averageRatingLabel.heightAnchor.constraint(equalTo: authorLabel.heightAnchor, multiplier: 1.2).isActive = true
        
        // Add Book Button
        contentView.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: averageRatingLabel.bottomAnchor, constant: 8).isActive = true
        addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        //addButton.bottomAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor).isActive = true
        //addButton.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
        //addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        addButton.widthAnchor.constraint(equalTo: titleLabel.widthAnchor).isActive = true
        addButton.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 1.5).isActive = true

        // Line Break
        contentView.addSubview(lineBreak)
        lineBreak.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 16).isActive = true
        lineBreak.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        lineBreak.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        lineBreak.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Description Label
        contentView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: lineBreak.bottomAnchor, constant: 16).isActive = true
        // this centerXAnchor is important (without it, the scrollView gets really wide)
        descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        //descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        //descriptionLabel.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        //descriptionTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        //descriptionTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        //descriptionTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true

        // Bottom Stack View (holds publisher, isbn, and length labels)
        contentView.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(publisherLabel)
        bottomStackView.addArrangedSubview(isbnLabel)
        bottomStackView.addArrangedSubview(lengthLabel)
        bottomStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        // Bottom Thing (change to genre tags later?)
        contentView.addSubview(dummyView)
        dummyView.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 16).isActive = true
        dummyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        //dummyView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        // this bottom anchor is important (makes scroll view scrollable basically)
        dummyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        dummyView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        dummyView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

class StarRatingStackView: UIStackView {
    
    /// Holds 5 star images insied
    var starsView: UIView!
    
    /// Array of star images
    var starsArray = [UIImageView]()
    
    // FIXME: give this a didSet later that calls updateStarRating
    /// How many stars should be filled in
    var ratingValue: Double? {
        didSet {
            updateStarRating()
        }
    }
    var starSize: Double = 20.0
    
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
        //let starSize = Int(20) // FIXME: should be based on view size?
        for i in 1...5 {
            let star = UIImageView()
            star.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(star)
            starsArray.append(star)
            star.tag = i
            star.contentMode = .scaleToFill
            star.frame = CGRect(x: 0,
                                y: 0,
                                width: starSize,
                                height: starSize)
            star.image = UIImage(named: "Stars_Chunky-AltoGray")
        }
        updateStarRating()
    }
    
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
