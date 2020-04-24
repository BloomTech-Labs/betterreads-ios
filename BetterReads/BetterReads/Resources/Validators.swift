//
//  Validators.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/24/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import UIKit

protocol ValidatorConvertible {
    func validated(_ value: String?) throws -> String
}

enum ValidatorType {
    case required
    case email
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .required: return RequiredFieldValidator()
        case .email: return EmailFieldValidator()
        }
    }
}

struct ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    func validated(_ value: String?) throws -> String {
        guard let unwrappedValue = value,
            !unwrappedValue.isEmpty else {
            throw ValidationError("Required field")
        }
        return unwrappedValue
    }
}

struct EmailFieldValidator: ValidatorConvertible {
    func validated(_ value: String?) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value!, options: [], range: NSRange(location: 0, length: value!.count)) == nil {
                throw ValidationError("Invalid e-mail Address")
            }
        } catch {
            throw ValidationError("Invalid e-mail Address")
        }
        return value!
    }
}

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}
