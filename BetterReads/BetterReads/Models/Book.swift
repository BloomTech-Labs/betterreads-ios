//
//  Book.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Holds the response you receive when searching for a book
struct SearchResult: Codable {
    let items: [Book]
    let totalItems: Int
}

/// Used in the search POST method
struct TypeQuery: Codable {
    var type: String
    var query: String
}

struct Book: Codable {
    let authors: [String]?
    let categories: [String]?
    let itemDescription: String?
    let googleID: String?
    let isEbook: Bool?
    let language: String?
    let pageCount: Int?
    let publisher: String?
    let smallThumbnail: String?
    let textSnippet: String?
    let thumbnail: String?
    let title: String?
    let webReaderLink: String?
    let averageRating: Double?
    let isbn10, isbn13, publishedDate: String?

    enum CodingKeys: String, CodingKey {
        case authors, categories
        case itemDescription = "description"
        case googleID = "googleId"
        case isEbook, language, pageCount, publisher, smallThumbnail, textSnippet, thumbnail, title, webReaderLink, averageRating, isbn10, isbn13, publishedDate
    }
}

// Book model from the docs
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
