//
//  User.swift
//  Readrr
//
//  Created by Alexander Supe on 4/14/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

struct User: Codable {
    var fullName: String? = nil
    var emailAddress: String
    var password: String
}
