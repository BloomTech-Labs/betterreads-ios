//
//  User.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/21/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

class User {
    let fullName: String
    var email: String
    var password: String
    
    init(fullName: String, email: String, password: String) {
        self.fullName = fullName
        self.email = email
        self.password = password
    }
}

//FIXME: Validate email with Email struct and EmailValidation.swift file
struct Email {
    private var string: String

    init(_ string: String) throws {
        try Validations.email(string)
        self.string = string
    }

    func address() -> String {
        return string
    }
}
