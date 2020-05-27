//
//  BookDetailViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit
import AVFoundation

class BookDetailViewController: UIViewController {

    @IBOutlet var webButtonLabel: UIBarButtonItem!
    // FIXME: give intrinsicContentSize a value so it's not -1,-1
    @IBAction func webButtonTapped(_ sender: UIBarButtonItem) {
        print("tapped web button")
        performSegue(withIdentifier: "PresentWebView", sender: self)
    }
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
        label.textColor = .tundra
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "by Stephenie Meyer"
        label.font = UIFont(name: "SourceSansPro-Light", size: 16)
        label.textColor = .tundra
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
        averageRatingLabel.textColor = .doveGray
        averageRatingLabel.textAlignment = .center
        return averageRatingLabel
    }()

    // FIXME: make button have default "pressing" animation that comes with storyboard buttons
    let addButton: UIButton = {
        let tempButton = UIButton(type: .custom) // .system
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        //tempButton.backgroundColor = .trinidadOrange
        tempButton.tintColor = .white
        tempButton.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 18)
        tempButton.setTitle("Add Book", for: .normal)
        tempButton.setTitle("In My Library", for: .disabled)
        tempButton.isEnabled = false
        tempButton.backgroundColor = .doveGray
        tempButton.addTarget(self, action: #selector(addBookToLibrary), for: .touchUpInside)
        tempButton.layer.cornerRadius = 5
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
        decriptionLabel.font = UIFont(name: "FrankRuhlLibre-Regular", size: 16)
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
        dummyView.font = UIFont(name: "SourceSansPro-Semibold", size: 16)
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

    @objc func addBookToLibrary() {
        print("add button tapped")
        AudioServicesPlaySystemSound(SystemSoundID(1105))
        addButton.buttonTap()

        let act = UIAlertController(title: "Track this", message: nil, preferredStyle: .actionSheet)
        act.addAction(UIAlertAction(title: "To be read", style: .default, handler: addBookToDefaultShelves))
        act.addAction(UIAlertAction(title: "In progress", style: .default, handler: addBookToDefaultShelves))
        act.addAction(UIAlertAction(title: "Finished", style: .default, handler: addBookToDefaultShelves))
        act.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        act.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(act, animated: true)
    }

    /// Adds book to default shelf based on title selected
    private func addBookToDefaultShelves(action: UIAlertAction) {
        print("action tapped")
        var readingStatus = 0
        switch action.title {
        case "To be read":
            print(1)
            readingStatus = 1
        case "In progress":
            print(2)
            readingStatus = 2
        case "Finished":
            print(3)
            readingStatus = 3
        default:
            print(0)
        }
        guard let book = book else { return }
        UserController.sharedLibraryController.addBookToLibrary(book: book, status: readingStatus) { (_) in
            DispatchQueue.main.async {
                print("Book added!")
                AudioServicesPlaySystemSound(SystemSoundID(1118))
                self.addButton.isEnabled = false
                self.addButton.backgroundColor = .doveGray
            }
        }
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

    // NEW
    var userBookDetail: UserBookDetail? {
        didSet {
            print(userBookDetail?.webReaderLink)
        }
    }

    /// Fetches detailed version of passed in book by it's bookId
    private func fetchBookById(bookId: Int) {
        print("called fetchBookById(bookId: Int)")
        spinner.startAnimating()
        UserController.sharedLibraryController.fetchBookById(bookId: bookId, completion: { (userBookDetail) in
            DispatchQueue.main.async {
                // NEW
                self.userBookDetail = userBookDetail
                // NEW
                self.titleLabel.text = userBookDetail?.title ?? "Untitled"

                if let author = userBookDetail?.authors {
                    self.authorLabel.text = "by " + author.removeTags(author)
                } else { self.authorLabel.text = "Unknown" }

                if let averageRating = userBookDetail?.averageRating, let doubleValue = Double(averageRating) {
                    self.ratingStackView.ratingValue = doubleValue
                    self.averageRatingLabel.text = String(format: "%.1f average rating", doubleValue)
                } else {
                    self.ratingStackView.ratingValue = 0.0
                    self.averageRatingLabel.text = "no rating"
                }

                if let itemDescription = userBookDetail?.itemDescription {
                    self.descriptionLabel.text = itemDescription.removeTags(itemDescription)
                } else { self.descriptionLabel.text = "No description"}

                self.publisherLabel.text = "Publisher: \(userBookDetail?.publisher ?? "No publisher")"
//                self.isbnLabel.text = "ISBN: \(userBookDetail?.isbn13 ?? "no ISBN")"
                self.isbnLabel.text = userBookDetail?.webReaderLink

                self.lengthLabel.text = "Length: \(userBookDetail?.pageCount ?? 0) pages"
                self.spinner.stopAnimating()
            }
        })
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        //navigationController?.navigationBar.tintColor = .white
        print("intrinsicContentSize = \(self.view.intrinsicContentSize)")
        //navigationController?.navigationBar.isHidden = false
        setupSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
        // To change status bar text to white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        // Transparent Nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    // To change status bar text back to black
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        super.viewWillDisappear(animated)
        // change back so status bar text black again
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .trinidadOrange
        // FIXME: change nav bar back to normal but it flashes a little now
        // for some reason, the homescreen nav bar works perfectly, no flash and not black background
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //nil, .default
        navigationController?.navigationBar.shadowImage = UIImage()
        // Setting Nav bar to NOT be translucent causes the black nav bar somehow
        //navigationController?.navigationBar.isTranslucent = false
    }

    private func updateViews() {
        guard let book = book else { print("no book in guard let"); return }
        addButton.isEnabled = true
        addButton.backgroundColor = .trinidadOrange
        titleLabel.text = book.title ?? "Untitled"
        authorLabel.text = "by \(book.authors?[0] ?? "Unknown")"
        ratingStackView.ratingValue = book.averageRating
        if let averageRatingText = book.averageRating {
            averageRatingLabel.text = "\(averageRatingText) average rating"
        } else { averageRatingLabel.text = "no rating" }
        descriptionLabel.text = book.itemDescription ?? "No description"
        publisherLabel.text = "Publisher: \(book.publisher ?? "No publisher")"
        isbnLabel.text = "ISBN: \(book.isbn13 ?? "None")"
        lengthLabel.text = "Length: \(book.pageCount ?? 0) pages"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentWebView" {
            print("PresentWebView Segue")
            if let navVC = segue.destination as? UINavigationController, let webVC = navVC.topViewController as? WebViewController {
                print("as? WVC")
                if let book = book, let link = book.webReaderLink {
                    let url = URL(string: link)
                    webVC.linkString = url?.usingHTTPS
                    print(url?.usingHTTPS)
                }
                if let userBookDetail = userBookDetail, let link = userBookDetail.webReaderLink {
                    webVC.linkString = URL(string: link)?.usingHTTPS
                    print(URL(string: link)?.usingHTTPS)
                }
//                if let userBookOnShelf = userBookOnShelf {
//                    webVC.linkString = userBookOnShelf.webReaderLink
//                }
            }
        }
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
        // height anchor used to be view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5
        blurredBackgroundView.heightAnchor.constraint(equalTo: blurredBackgroundView.widthAnchor,
                                                      multiplier: 0.8).isActive = true

        // blur effect
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        blurView.frame = blurredBackgroundView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // add blurView over blurredBackgroundView
        blurredBackgroundView.addSubview(blurView)

        // Book Image View
        contentView.addSubview(bookCoverImageView) // contentView.topAnchor, constant: 100
        //bookCoverImageView.centerYAnchor.constraint(equalTo: blurredBackgroundView.centerYAnchor).isActive = true
        //bookCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100).isActive = true
        //bookCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        bookCoverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        bookCoverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalTo: bookCoverImageView.widthAnchor,
                                                   multiplier: 1.5).isActive = true
        bookCoverImageView.bottomAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor,
                                                   constant: -40).isActive = true
        // Title Label
        contentView.addSubview(titleLabel)
        //titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: blurredBackgroundView.bottomAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        //titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        // Author Label
        contentView.addSubview(authorLabel)
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        //authorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        //authorLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true

        // Rating Stack View
        contentView.addSubview(ratingStackView)
        ratingStackView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12).isActive = true
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
        addButton.topAnchor.constraint(equalTo: averageRatingLabel.bottomAnchor, constant: 16).isActive = true
        addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        //addButton.bottomAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        //addButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4).isActive = true
        //addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor, multiplier: 0.3).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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

extension String {
    /// Removes all random HTML tags that string could contain and returns a clean one
    func removeTags(_ string: String) -> String {
        var cleanString = string
        let tags = ["<br>", "<b>", "</b>", "{\"", "\"}", "<i>", "</i>", "<p>", "</p>"]
        for tag in tags {
            if tag == "<br>" {
                // tag was a break, add a new line
                cleanString = cleanString.replacingOccurrences(of: tag, with: "\n")
            } else {
                // any other case, replace tag with "remove" tag
                cleanString = cleanString.replacingOccurrences(of: tag, with: "")
            }
        }
        return cleanString
    }
}

///// Removes all random HTML tags that string could contain and returns a clean one
//func removeTags(_ string: String) -> String {
//    var cleanString = string
//    print("unclean: " + string)
//    let tags = ["<br>", "<b>", "</b>", "{\"", "\"}", "<i>", "</i>"]
//    for tag in tags {
//        cleanString = cleanString.replacingOccurrences(of: tag, with: "")
//    }
//    print("clean:" + cleanString)
//    return cleanString
//}
