//
//  BookDetailViewController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/6/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    // FIXME: make these properties with an ! at the end?
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .cyan
        return v
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
//        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // FIXME: make this numberOfLines = 0 for long authors?
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Stephenie Meyer"
//        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // FIXME: make this like the star view in SearchResultsView (make this custom later?)
    let ratingView: UIView = {
        let tempView = UIView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
//        tempView.backgroundColor = .black
        return tempView
    }()
    
    private var starsArray = [UIImageView]()
    private var starSpacing: Int = 4 // change to double/float?
    
    // FIXME: Average Rating label (3.12 avg rating / or No ratings)
    // Average Rating Label
    
    // FIXME: make button have default "pressing" animation that comes with storyboard buttons
    let addButton: UIButton = {
        let tempButton = UIButton(type: .system)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.backgroundColor = .trinidadOrange
        tempButton.tintColor = .white
        tempButton.setTitle("Add Book", for: .normal)
        tempButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        tempButton.layer.cornerRadius = 5
        return tempButton
    }()
        
    let lineBreak: UIView = {
        let lb = UIView()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.layer.cornerRadius = 5
        lb.backgroundColor = .altoGray
        return lb
    }()
    
    /// This is a label because it's height can be easily based on it's content (text) inside so scroll view changes accordingly
    let descriptionLabel: UILabel = {
        let tv = UILabel()
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = .magenta
        tv.text = "With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two."
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
    
    private func setupSubviews() {
        // Scroll View
        // add the scroll view to self.view
        self.view.addSubview(scrollView)
        // constrain the scroll view to 8-pts on each side
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        // Book Image View
        scrollView.addSubview(bookCoverImageView)
        bookCoverImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        bookCoverImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        //bookCoverImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        bookCoverImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.3).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalTo: bookCoverImageView.widthAnchor, multiplier: 1.5).isActive = true
        
        // Title Label
        // add labelOne to the scroll view
        scrollView.addSubview(titleLabel)
        // constrain labelOne to left & top with 16-pts padding
        // this also defines the left & top of the scroll content
        //titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bookCoverImageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
        
        // Author Label
        // add authorLabel to the scroll view
        scrollView.addSubview(authorLabel)
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
        //authorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        //authorLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        
        // Rating View
        scrollView.addSubview(ratingView)
        ratingView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8).isActive = true
        ratingView.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
        ratingView.widthAnchor.constraint(equalTo: authorLabel.widthAnchor).isActive = true
        ratingView.heightAnchor.constraint(equalTo: authorLabel.heightAnchor, multiplier: 1.2).isActive = true
        
        // Stars in Rating View
        let starSize = Int(20) // FIXME: should be based on cell size?
//        let starSize = Int(ratingView.frame.size.height * CGFloat(0.10)) // FIXME: should be based on cell size?
        for i in 1...5 {
            let star = UIImageView()
            ratingView.addSubview(star)
            starsArray.append(star)
            star.tag = i
            star.frame = CGRect(x: ((starSize + starSpacing) * (i - 1)),
                                y: 0,
                                width: starSize,
                                height: starSize)
//            star.image = UIImage(named: "Stars_Chunky-AltoGray")
            star.image = UIImage(named: "Stars_Chunky-Tundra")
        }

        
        // Average Rating Label
        
        // Add Book Button
        scrollView.addSubview(addButton)
//        addButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8).isActive = true
        addButton.bottomAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
        addButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        //addButton.widthAnchor.constraint(equalTo: authorLabel.widthAnchor).isActive = true
        addButton.heightAnchor.constraint(equalTo: authorLabel.heightAnchor, multiplier: 2).isActive = true
        
        // Line Break
        scrollView.addSubview(lineBreak)
        lineBreak.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor, constant: 16).isActive = true
        lineBreak.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        lineBreak.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        lineBreak.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Description Label
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: lineBreak.bottomAnchor, constant: 16).isActive = true
        // this centerXAnchor is important (without it, the scrollView gets really wide)
        descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        //descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
        //descriptionLabel.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        //descriptionTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        //descriptionTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        //descriptionTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
        // Bottom Thing (change to genre tags later?)
        scrollView.addSubview(dummyView)
        dummyView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
        dummyView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        //dummyView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        // this bottom anchor is important (makes scroll view scrollable basically)
        dummyView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
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
