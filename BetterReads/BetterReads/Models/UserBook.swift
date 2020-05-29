//
//  UserBook.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/19/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Used when getting books from user's library
struct UserBook: Codable {
    let userBooksId: Int?
    let bookId: Int?
    let googleId: String?
    let title: String?
    let authors: String?
    let readingStatus: Int?
    let favorite: Bool?
    let categories: String?
    let thumbnail: String?
    let pageCount: Int?
    let dateStarted: String?
    let dateEnded: String?
    let dateAdded: String?
    let userRating: Double?
}
