//
//  String+Additions.swift
//  Readrr
//
//  Created by Alexander Supe on 4/15/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let substrings = self.split(separator: "@")
        if substrings.count < 2 || !(substrings.last?.contains(".") ?? false) { return false }
        return true
    }
}
