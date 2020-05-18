//
//  BookDetailViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    // FIXME: make back arrow white with no text
    // FIXME: give intrinsicContentSize a value so it's not -1,-1
    // FIXME: make these properties with an ! at the end???
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        //v.backgroundColor = .cyan
        return scrollView
    }()
    let blurredBackgroundView: UIImageView = {
        let backgroundView = UIImageView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named: "twilightBookCover")
        backgroundView.contentMode = .scaleToFill
        return backgroundView
    }()
    let bookCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        iv.backgroundColor = .yellow
        imageView.image = UIImage(named: "twilightBookCover")
        imageView.contentMode = .scaleAspectFill // used to be .scaleToFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    // FIXME: make this numberOfLines = 0 for long titles?
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Twilight Breaking Dawn"
        label.font = UIFont(name: "FrankRuhlLibre-Regular", size: 24)
        label.textAlignment = .center
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
        let ratingStackView = StarRatingStackView()
        ratingStackView.axis = .horizontal
        //rv.distribution = .fillEqually
        ratingStackView.spacing = 4
        ratingStackView.ratingValue = 5.0
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        return ratingStackView
    }()
    // FIXME: Average Rating label (3.12 avg rating / or No ratings)
    // Average Rating Label
    let averageRatingLabel: UILabel = {
        let averageRatingLabel = UILabel()
        averageRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        averageRatingLabel.text = "4.7 average rating"
        averageRatingLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14)
        averageRatingLabel.textAlignment = .center
        return averageRatingLabel
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
        let lineBreak = UIView()
        lineBreak.translatesAutoresizingMaskIntoConstraints = false
        lineBreak.layer.cornerRadius = 5
        lineBreak.backgroundColor = .altoGray
        return lineBreak
    }()
    let bottomStackView: UIStackView = {
        let bottomStackView = UIStackView()
        bottomStackView.axis = .vertical
        bottomStackView.distribution = .equalSpacing
        bottomStackView.spacing = 4
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        return bottomStackView
    }()
    let publisherLabel: UILabel = {
        let publisherLabel = UILabel()
        publisherLabel.text = "Publisher: Little, Brown Books for Young Readers, 2008"
        publisherLabel.font = UIFont(name: "SourceSansPro-Light", size: 16)
        publisherLabel.numberOfLines = 0
        return publisherLabel
    }()
    let isbnLabel: UILabel = {
        let isbnLabel = UILabel()
        isbnLabel.text = "ISBN: 9780316032834"
        isbnLabel.font = UIFont(name: "SourceSansPro-Light", size: 16)
        return isbnLabel
    }()
    let lengthLabel: UILabel = {
        let lengthLabel = UILabel()
        lengthLabel.text = "Length: 768 pages"
        lengthLabel.font = UIFont(name: "SourceSansPro-Light", size: 16)
        return lengthLabel
    }()
    /// Label (it's height can be easily based on it's content (text) inside so scroll view changes accordingly)
    let descriptionLabel: UILabel = {
        let decriptionLabel = UILabel()
        decriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .magenta
        decriptionLabel.text = """
                        With 160 million copies of the Twilight Saga sold worldwide,
                        this addictive love story between a teenage girl and
                        a vampire redefined romance for a generation.
                        Here is the series finale.
                        """
        decriptionLabel.numberOfLines = 0
        return decriptionLabel
    }()
    let dummyView: UILabel = {
        let dummyView = UILabel()
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        dummyView.layer.cornerRadius = 5
        dummyView.backgroundColor = .tundra
        dummyView.textColor = .white
        dummyView.textAlignment = .center
        dummyView.text = "Fiction"
        dummyView.clipsToBounds = true
        return dummyView
    }()
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        //cv.backgroundColor = .yellow
        return contentView
    }()
    // FIXME: add sound effect for add book to library? (similar to App store purchase success)?
    @objc func showAlert() {
        print("add button tapped")
        addButton.performFlare()
    }
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    var passedInImage: UIImage?
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        navigationController?.navigationBar.tintColor = .white
        print("intrinsicContentSize = \(self.view.intrinsicContentSize)")
        navigationController?.navigationBar.isHidden = false
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
        navigationController?.navigationBar.tintColor = .trinidadOrange
        //navigationController?.navigationBar.isTranslucent = false
    }
    // FIXME: button might be weird because contentSize is -1, -1
//    override var intrinsicContentSize: CGSize {
//      //let width = componentsWidth + componentsSpacing
//        return CGSize(width: view.bounds.width, height: view.bounds.height)
//    }
    private func updateViews() {
        //guard isViewLoaded else { print("view not loaded yet"); return }
        guard let book = book else { print("no book in guard let"); return }
        titleLabel.text = book.title
        //bookCoverImageView.image = UIImage()book.thumbnail
        authorLabel.text = "by \(book.authors?[0] ?? "Unknown")"
        ratingStackView.ratingValue = book.averageRating
        averageRatingLabel.text = "\(book.averageRating ?? 0) average rating"
        descriptionLabel.text = book.textSnippet
        publisherLabel.text = "Publisher: \(book.publisher ?? "No publisher")"
        isbnLabel.text = "ISBN: \(book.isbn13 ?? "")"
        lengthLabel.text = "Length: \(book.pageCount ?? 0) pages"
    }
    private func setupSubviews() {
        // Scroll View
        // add the scroll view to self.view
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
        blurredBackgroundView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                      multiplier: 0.5).isActive = true
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
        bookCoverImageView.heightAnchor.constraint(equalTo: bookCoverImageView.widthAnchor,
                                                   multiplier: 1.5).isActive = true
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
        // FIXME: change button width so its always maybe 0.4 of content view width? might cause bugs
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
        //descriptionTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
        // constant: -20).isActive = true
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
        print("intrinsicContentSize at end = \(self.view.intrinsicContentSize)")
    }
}
