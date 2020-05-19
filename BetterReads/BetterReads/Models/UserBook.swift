//
//  UserBook.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/19/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

struct UserBook: Codable {
    let userBooksId: Int?
    let bookId: Int?
    let googleId: String?
    let title: String?
    let authors: String? // could this be an array?
    let readingStatus: Int?
    let favorite: Bool?
    let categories: String?
    let thumbnail: String?
    let pageCount: Int?
    let dateStarted: String? // DATETIME
    let dateEnded: String? // DATETIME
    let dateAdded: String? // DATETIME
    let userRating: Double? // DECIMAL
}
