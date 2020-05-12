//
//  Book.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Rough draft of our Book model
//class Book: Codable {
//
//    let title: String
//    /// array of authors
//    let author: String
//    let cover: String
//    let rating: Double // should this be optional since some might have no rating?
//
//    enum CodingKeys: String, CodingKey {
//        case title
//        case author = "authors"
//        case cover = "thumbnail"
//        case rating = "averageRating"
//    }
//
//    init(title: String, author: String, cover: String, rating: Double) {
//        self.title = title
//        self.author = author
//        self.cover = cover
//        self.rating = rating
//    }
//}

//struct Items: Codable {
//    var items: [Book]
//}

struct TypeQuery: Codable {
    var type: String
    var query: String
}

// TEMP, DELETE LATER!

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recommendation = try? newJSONDecoder().decode(Recommendation.self, from: jsonData)

// MARK: - FakeBook
struct SearchResult: Codable {
    let items: [Book]
    let totalItems: Int
}

// MARK: - Item
struct Book: Codable {
    let authors: [String]?
    let categories: [String]?
    let itemDescription: String?
    let googleID: String? // wasn't optional
    let isEbook: Bool? // wasn't optional
    let language: String? // used to be Language and not optional
    let pageCount: Int?
    let publisher: String? // wasn't optional
    let smallThumbnail: String? // wasn't optional
    let textSnippet: String?
    let thumbnail: String? // wasn't optional
    let title: String? // wasn't optional
    let webReaderLink: String? // wasn't optional
    let averageRating: Double?
    let isbn10, isbn13, publishedDate: String?

    enum CodingKeys: String, CodingKey {
        case authors, categories
        case itemDescription = "description"
        case googleID = "googleId"
        case isEbook, language, pageCount, publisher, smallThumbnail, textSnippet, thumbnail, title, webReaderLink, averageRating, isbn10, isbn13, publishedDate
    }
}

//enum Author: String, Codable {
//    case aMHeath = "A.M. Heath"
//    case georgeOrwell = "George Orwell"
//    case najoudEnsaff = "Najoud Ensaff"
//}

//enum Language: String, Codable {
//    case en = "en"
//}

// from the docs
/*
 {
   googleId: STRING,
   title: STRING,
   authors: STRING,
   publisher: STRING,
   publishedDate: STRING,
   description: STRING,
   isbn10: STRING,
   isbn13: STRING,
   pageCount: INTEGER,
   categories: STRING,
   thumbnail: STRING,
   smallThumbnail: STRING,
   language: STRING,
   webReaderLink: STRING,
   textSnippet: STRING,
   isEbook: BOOLEAN,
   averageRating: DECIMAL
 }
 */
