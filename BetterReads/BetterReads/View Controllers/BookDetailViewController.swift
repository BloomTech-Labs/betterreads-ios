//
//  BookDetailViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    // FIXME: give intrinsicContentSize a value so it's not -1,-1
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        imageView.image = UIImage(named: "twilightBookCover")
        imageView.contentMode = .scaleAspectFill // used to be .scaleToFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Twilight Breaking Dawn"
        label.font = UIFont(name: "FrankRuhlLibre-Regular", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "by Stephenie Meyer"
        label.font = UIFont(name: "SourceSansPro-Light", size: 16)
        label.numberOfLines = 2
        label.textAlignment = .center
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
//        decriptionLabel.backgroundColor = .magenta
        decriptionLabel.text = ""
        decriptionLabel.numberOfLines = 4 // can change by pressing button?
        return decriptionLabel
    }()

    /// Button that exands the rest of the description label
    let readMoreButton: UIButton = {
        let tempReadMoreButton = UIButton(type: .system)
        tempReadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        tempReadMoreButton.backgroundColor = .clear
//        tempReadMoreButton.setTitle("", for: .normal)
        tempReadMoreButton.addTarget(self, action: #selector(expandDescriptionLabel), for: .touchUpInside)
        return tempReadMoreButton
    }()

    /// Placeholder for where genre tags should go
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

    /// Pinned to Scroll View and holds all other elements to prevent issues with scroll view
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        //cv.backgroundColor = .yellow
        return contentView
    }()

    /// Spinning wheel activity indicator for when network call takes too long
    let spinner: UIActivityIndicatorView = {
        let tempActivityView = UIActivityIndicatorView(style: .medium)
        tempActivityView.translatesAutoresizingMaskIntoConstraints = false
        tempActivityView.color = .tundra
        tempActivityView.backgroundColor = .white
        return tempActivityView
    }()

    // FIXME: add sound effect for add book to library? (similar to App store purchase success)?
    @objc func showAlert() {
        print("add button tapped")
        addButton.performFlare()
    }

    /// Expands or collapses description (change max number of lines here and in the descriptionLabel property)
    @objc func expandDescriptionLabel() {
        print("expandDescriptionLabel called")
        descriptionLabel.numberOfLines = descriptionLabel.numberOfLines == 0 ? 4 : 0
    }

    /// Book that comes from Home or Search screen
    var book: Book? {
        didSet {
            updateViews()
        }
    }

    /// UserBook that comes from a Default shelf
    var userBook: UserBook? {
        didSet {
            guard let bookId = userBook?.bookId else { return }
            fetchBookById(bookId: bookId)
        }
    }

    /// UserBookOnShelf that comes from a Custom Shelf
    var userBookOnShelf: UserBookOnShelf? {
        didSet {
            guard let bookId = userBookOnShelf?.bookId else { return }
            fetchBookById(bookId: bookId)
        }
    }

    /// Fetches detailed version of passed in book by it's bookId
    private func fetchBookById(bookId: Int) {
        print("called fetchBookById(bookId: Int)")
        spinner.startAnimating()
        UserController.sharedLibraryController.fetchBookById(bookId: bookId, completion: { (userBookDetail) in
            DispatchQueue.main.async {
                self.titleLabel.text = userBookDetail?.title ?? "Untitled"
                self.authorLabel.text = "by \(userBookDetail?.authors ?? "Unknown")"
                if let averageRating = userBookDetail?.averageRating, let doubleValue = Double(averageRating) {
                    self.ratingStackView.ratingValue = doubleValue
                    self.averageRatingLabel.text = String(format: "%.1f average rating", doubleValue)
                } else {
                    self.ratingStackView.ratingValue = 0.0
                    self.averageRatingLabel.text = "no rating"
                }
                self.descriptionLabel.text = userBookDetail?.itemDescription ?? "No description"
                self.publisherLabel.text = "Publisher: \(userBookDetail?.publisher ?? "No publisher")"
                self.isbnLabel.text = "ISBN: \(userBookDetail?.isbn13 ?? "no ISBN")"
                self.lengthLabel.text = "Length: \(userBookDetail?.pageCount ?? 0) pages"
                self.spinner.stopAnimating()
            }
        })
    }

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
        // Transparent Nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    // To change status bar text back to black
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .trinidadOrange
        // FIXME: change nav bar back to normal but it flashes a little now
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
    }
    // FIXME: button might be weird because contentSize is -1, -1

    private func updateViews() {
        guard let book = book else { print("no book in guard let"); return }
        titleLabel.text = book.title
        authorLabel.text = "by \(book.authors?[0] ?? "Unknown")"
        ratingStackView.ratingValue = book.averageRating
        averageRatingLabel.text = "\(book.averageRating ?? 0) average rating"
        descriptionLabel.text = book.itemDescription
        publisherLabel.text = "Publisher: \(book.publisher ?? "No publisher")"
        isbnLabel.text = "ISBN: \(book.isbn13 ?? "")"
        lengthLabel.text = "Length: \(book.pageCount ?? 0) pages"
    }

    private func setupSubviews() {

        // Scroll View
        // add the scroll view to self.view
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        // Very important
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
        contentView.addSubview(titleLabel)
        //titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        //titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        // Author Label
        contentView.addSubview(authorLabel)
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        //authorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        //authorLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true

        // Rating Stack View
        contentView.addSubview(ratingStackView)
        ratingStackView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8).isActive = true
        ratingStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        ratingStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33).isActive = true
        ratingStackView.heightAnchor.constraint(equalTo: ratingStackView.widthAnchor, multiplier: 0.18).isActive = true

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
        addButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
        addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor, multiplier: 0.3).isActive = true

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

        // Read More Button
        contentView.addSubview(readMoreButton)
        readMoreButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor).isActive = true
        readMoreButton.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor).isActive = true
        readMoreButton.heightAnchor.constraint(equalTo: descriptionLabel.heightAnchor, multiplier: 0.9).isActive = true
        readMoreButton.widthAnchor.constraint(equalTo: descriptionLabel.widthAnchor).isActive = true

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

        // Spinner
        self.view.addSubview(spinner)
        spinner.topAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor).isActive = true
        spinner.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        spinner.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        spinner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
