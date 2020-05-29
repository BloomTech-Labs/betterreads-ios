//
//  UserBookOnShelf.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/19/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Used when grabbing all the user's shelves (UserShelf) with books in them
/// These are similar to UserBooks, except they have a shelfId and shelfName
struct UserBookOnShelf: Codable {
    let bookId: Int?
    let googleId: String?
    let title: String?
    let authors: String?
    let publisher: String?
    let publishedDate: String?
    let itemDescription: String?
    let isbn10: String?
    let isbn13: String?
    let pageCount: Int?
    let categories: String?
    let thumbnail: String?
    let smallThumbnail: String?
    let language: String?
    let webReaderLink: String?
    let textSnippet: String?
    let isEbook: Bool?
    let averageRating: String?
    let shelfId: Int?
    let userId: Int?
    let shelfName: String?
    let userRating: String?
    let readingStatus: Int?
    let favorite: Bool?

    enum CodingKeys: String, CodingKey {
        case bookId = "id"
        case googleId
        case title
        case authors
        case publisher
        case publishedDate
        case itemDescription = "description"
        case isbn10
        case isbn13
        case pageCount
        case categories
        case thumbnail
        case smallThumbnail
        case language
        case webReaderLink
        case textSnippet
        case isEbook
        case averageRating
        case shelfId
        case userId
        case shelfName
        case userRating
        case readingStatus
        case favorite
    }
}
