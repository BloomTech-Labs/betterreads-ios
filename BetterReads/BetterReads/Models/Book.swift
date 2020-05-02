//
//  Book.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Rough draft of our Book model
class Book: Codable {
    
    let title: String
    /// array of authors
    let author: String
    let cover: String
    let rating: Double // should this be optional since some might have no rating?
    
    enum CodingKeys: String, CodingKey {
        case title
        case author = "authors"
        case cover = "thumbnail"
        case rating = "averageRating"
    }
    
    init(title: String, author: String, cover: String, rating: Double) {
        self.title = title
        self.author = author
        self.cover = cover
        self.rating = rating
    }
}

struct Items: Codable {
    var items: [Book]
}

struct TypeQuery: Codable {
    var type: String
    var query: String
}

// TEMP, DELETE LATER!

// MARK: - FakeBook
struct FakeBook: Codable {
    let items: [Item]
    let totalItems: Int
}

// MARK: - Item
struct Item: Codable {
    let authors: [Author]?
    let categories: [String]?
    let itemDescription: String?
    let googleID: String
    let isEbook: Bool
    let language: Language
    let pageCount: Int?
    let publisher: String
    let smallThumbnail: String
    let textSnippet: String?
    let thumbnail: String
    let title: String
    let webReaderLink: String
    let averageRating: Double?
    let isbn10, isbn13, publishedDate: String?

    enum CodingKeys: String, CodingKey {
        case authors, categories
        case itemDescription = "description"
        case googleID = "googleId"
        case isEbook, language, pageCount, publisher, smallThumbnail, textSnippet, thumbnail, title, webReaderLink, averageRating, isbn10, isbn13, publishedDate
    }
}

enum Author: String, Codable {
    case aMHeath = "A.M. Heath"
    case georgeOrwell = "George Orwell"
    case najoudEnsaff = "Najoud Ensaff"
}

enum Language: String, Codable {
    case en = "en"
}

