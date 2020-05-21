//
//  User.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/21/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

class User: Codable {
    let userID: Int
    let fullName: Name
    var emailAddress: String
    init(userID: Int, fullName: Name, emailAddress: String) {
        self.userID = userID
        self.fullName = fullName
        self.emailAddress = emailAddress
    }
}

struct Name: Codable {
    let first: String
    let last: String
    init(first: String, last: String) {
        self.first = first
        self.last = last
    }
}
