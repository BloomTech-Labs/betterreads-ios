//
//  UserShelf.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/19/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

struct UserShelf: Codable {
    let shelfId: Int?
    let shelfName: String?
    let book: [UserBookOnShelf]?
    let userId: Int?
    let isPrivate: Bool?
}
