//
//  UserBookOnShelf.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/19/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Used when grabbing all the user's shelves (UserShelf) with books in them
struct UserBookOnShelf: Codable {
    let id: Int?
    let googleId, title, authors, publisher: String?
    let publishedDate, description, isbn10, isbn13: String?
    let pageCount: Int?
    let categories: String?
    let thumbnail, smallThumbnail: String?
    let language: String?
    let webReaderLink: String?
    let textSnippet: String?
    let isEbook: Bool?
    let averageRating: String?
    let shelfId, userId: Int?
    let shelfName: String?
    let userRating: String?
    let readingStatus: Int?
    let favorite: Bool?
}
