//
//  Book.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Rough draft of our Book model
class Book: Decodable {
    
    let title: String
    let author: String
    let cover: String
    let rating: Double
    
    init(title: String, author: String, cover: String, rating: Double) {
        self.title = title
        self.author = author
        self.cover = cover
        self.rating = rating
    }
}
