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
    let userId: Int?
    let shelfName: String?
    let isPrivate: Bool?
}
