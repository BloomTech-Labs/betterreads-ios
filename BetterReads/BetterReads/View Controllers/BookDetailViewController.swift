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
            v.backgroundColor = .cyan
            return v
        }()
        
        let bookCoverImageView: UIImageView = {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.backgroundColor = .yellow
            iv.image = UIImage(named: "twilightBookCover")
            iv.contentMode = .scaleAspectFit // .scaleToFill //mayhaps?
            iv.layer.cornerRadius = 5
            return iv
        }()
        
        // FIXME: make this numberOfLines = 0
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Twiligh Breaking Dawn"
            label.backgroundColor = .red
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        // FIXME: make this numberOfLines = 0 for long authors?
        let authorLabel: UILabel = {
            let label = UILabel()
            label.text = "Stephenie Meyer"
            label.backgroundColor = .green
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let ratingView: UIView = {
            let tempView = UIView()
            tempView.translatesAutoresizingMaskIntoConstraints = false
            tempView.backgroundColor = .blue
            return tempView
        }()
        
        let addButton: UIButton = {
            let tempButton = UIButton()
            tempButton.translatesAutoresizingMaskIntoConstraints = false
            tempButton.backgroundColor = .orange
            tempButton.setTitle("Add Book", for: .normal)
            tempButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
            tempButton.layer.cornerRadius = 5
            return tempButton
        }()
        
        let descriptionLabel: UILabel = {
            let tv = UILabel()
            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.backgroundColor = .magenta
            tv.text = "With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two. With 160 million copies of the Twilight Saga sold worldwide, this addictive love story between a teenage girl and a vampire redefined romance for a generation. For readers hungry for more, here is book two."
            tv.numberOfLines = 0
            return tv
        }()

        let dummyView: UILabel = {
            let dv = UILabel()
            dv.translatesAutoresizingMaskIntoConstraints = false
            dv.backgroundColor = .blue
            dv.text = "Fiction"
            return dv
        }()
        
        @objc func showAlert() {
            print("add button tapped")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // FIXME: add line break to split up top and bottom
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
            bookCoverImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.4).isActive = true
            bookCoverImageView.heightAnchor.constraint(equalTo: bookCoverImageView.widthAnchor, multiplier: 1.4).isActive = true
            
            // Title Label
            // add labelOne to the scroll view
            scrollView.addSubview(titleLabel)
            // constrain labelOne to left & top with 16-pts padding
            // this also defines the left & top of the scroll content
            //titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
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
            
            // Add Book Button
            scrollView.addSubview(addButton)
            addButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 8).isActive = true
            addButton.leadingAnchor.constraint(equalTo: bookCoverImageView.trailingAnchor, constant: 8).isActive = true
            addButton.widthAnchor.constraint(equalTo: authorLabel.widthAnchor).isActive = true
            addButton.heightAnchor.constraint(equalTo: authorLabel.heightAnchor, multiplier: 2).isActive = true
            
            // Description Text View
            scrollView.addSubview(descriptionLabel)
            descriptionLabel.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor, constant: 16).isActive = true
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
            //descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
            //descriptionLabel.heightAnchor.constraint(equalToConstant: 1000).isActive = true
            
            //descriptionTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
            //descriptionTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
            //descriptionTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
            
            scrollView.addSubview(dummyView)
            dummyView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
            dummyView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            dummyView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true

            //        descriptionTextView.text = """
    //        self.view.addSubview(scrollView)
    //        // constrain the scroll view to 8-pts on each side
    //        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
    //        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    //        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
    //        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    //        scrollView.addSubview(bookCoverImageView)
    //        bookCoverImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
    //        bookCoverImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    //        bookCoverImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7).isActive = true
    //        bookCoverImageView.heightAnchor.constraint(equalTo: bookCoverImageView.widthAnchor, multiplier: 1.4).isActive = true
    //        // add labelOne to the scroll view
    //        scrollView.addSubview(titleLabel)
    //        // constrain labelOne to left & top with 16-pts padding
    //        // this also defines the left & top of the scroll content
    //        titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    //        titleLabel.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor, constant: 16.0).isActive = true
    //        // add authorLabel to the scroll view
    //        scrollView.addSubview(authorLabel)
    //        authorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
    //        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
    //        authorLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0).isActive = true
    //        authorLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
    //        """
            
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
