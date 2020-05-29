//
//  UserBookDetail.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/19/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Used when you search a book by its bookId
/// This is very similar to a UserBook, it this one has additional properties
/// Why the backend doesn't just return these instead of UserBooks is not clear to me
struct UserBookDetail: Codable {
    let bookId: Int?
    let userBooksId: Int?
    let googleId: String?
    let isbn10: String?
    let isbn13: String?
    let readingStatus: Int?
    let dateStarted: String?
    let dateEnded: String?
    let dateAdded: String?
    let favorite: Bool?
    let userRating: Double?
    let title: String?
    let authors: String?
    let categories: String?
    let thumbnail: String?
    let pageCount: Int?
    let publisher: String?
    let publishedDate: String?
    let itemDescription: String?
    let textSnippet: String?
    let language: String?
    let webReaderLink: String?
    let isEbook: Bool?
    let averageRating: String?

    enum CodingKeys: String, CodingKey {
        case bookId
        case userBooksId
        case googleId
        case isbn10
        case isbn13
        case readingStatus
        case dateStarted
        case dateEnded
        case dateAdded
        case favorite
        case userRating
        case title
        case authors
        case categories
        case thumbnail
        case pageCount
        case publisher
        case publishedDate
        case itemDescription = "description"
        case textSnippet
        case language
        case webReaderLink
        case isEbook
        case averageRating
    }
}
