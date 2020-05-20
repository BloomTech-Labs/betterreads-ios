//
//  UserShelf.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/19/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/// Has books property that has all UserBookOnShelf in that UserShelf
struct UserShelf: Codable {
    let shelfId: Int?
    let shelfName: String?
    let books: [UserBookOnShelf]?
    let userId: Int?
    let isPrivate: Bool?
}

struct BooksForRecommendations: Encodable {
    let books: [UserBookOnShelf]
}
