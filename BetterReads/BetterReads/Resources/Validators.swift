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
    case required(field: String)
    case email(field: String)
    case password(field: String)
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .required(let fieldName): return RequiredFieldValidator(fieldName)
        case .email(let fieldName): return EmailFieldValidator(fieldName)
        case .password(let fieldName): return PasswordFieldValidator(fieldName)
        }
    }
}

struct ValidationError: Error {
    var message: String
    var fieldName: String
    init(message: String, fieldName: String) {
        self.message = message
        self.fieldName = fieldName
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    init(_ field: String) {
        fieldName = field
    }
    func validated(_ value: String?) throws -> String {
        guard let unwrappedValue = value,
            !unwrappedValue.isEmpty else {
            throw ValidationError(message: "Required field", fieldName: fieldName)
        }
        return unwrappedValue
    }
}

struct EmailFieldValidator: ValidatorConvertible {
    private let fieldName: String
    private let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    init(_ field: String) {
        fieldName = field
    }
    func validated(_ value: String?) throws -> String {
        guard let unwrappedValue = value,
            !unwrappedValue.isEmpty else {
            throw ValidationError(message: "Required field", fieldName: fieldName)
        }
        do {
            if try NSRegularExpression(pattern: pattern,
                                       options: .caseInsensitive)
                .firstMatch(in: value!, options: [], range: NSRange(location: 0, length: value!.count)) == nil {
                throw ValidationError(message: "Invalid email address", fieldName: fieldName)
            }
        } catch {
            throw ValidationError(message: "Invalid email address", fieldName: fieldName)
        }
        return value!
    }
}

struct PasswordFieldValidator: ValidatorConvertible {
    private let fieldName: String
    init(_ field: String) {
        fieldName = field
    }
    func validated(_ value: String?) throws -> String {
        guard let unwrappedValue = value, unwrappedValue != ""
            else { throw ValidationError(message: "Required field", fieldName: fieldName) }
        guard unwrappedValue.count >= 6
            else { throw ValidationError(message: "Must be at least 6 characters", fieldName: fieldName) }
        do {
            if try NSRegularExpression(pattern: "^(?=.*?[A-Za-z])(?=.*?[0-9]).{6,}$",
                                       options: .caseInsensitive).firstMatch(in: unwrappedValue,
                                                                             options: [],
                                                                             range: NSRange(
                                                                                location: 0,
                                                                                length: unwrappedValue.count)) == nil {
                throw ValidationError(message: "Must be at least 6 characters, with at least 1 number",
                                      fieldName: fieldName)
            }
        } catch {
            throw ValidationError(message: "Must be at least 6 characters, with at least 1 number",
                                  fieldName: fieldName)
        }
        return unwrappedValue
    }
}

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = VaildatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}
