//
//  User.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/21/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

class User: Codable {
    let id: Int
    let fullName: String
    var emailAddress: String
    init(id: Int, fullName: String, emailAddress: String) {
        self.id = id
        self.fullName = fullName
        self.emailAddress = emailAddress
    }
}
