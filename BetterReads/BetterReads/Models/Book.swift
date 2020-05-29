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

/// Used to post a  Book to user's Library
struct PostBookStruct: Encodable {
    let book: Book
    let readingStatus: Int
    let favorite: Bool
}

/// Used to post a Book to a user custom shelf
struct PostBookToShelfStruct: Encodable {
    let book: Book
    let readingStatus: Int
    let favorite: Bool
    let userRating: Double
}

/// Books are returned in Recommendations and Search Results
/// NYT books can be decoded as Books, but are unfit to be added to library
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
        case isEbook, language, pageCount, publisher, smallThumbnail,
        textSnippet, thumbnail, title, webReaderLink, averageRating, isbn10, isbn13, publishedDate
    }
}
