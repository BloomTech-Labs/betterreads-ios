//
//  UserController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/21/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case existingUser
}

class UserController {
    typealias CompletionHandler = (Error?) -> Void

    func signUp(user: User, completion: @escaping CompletionHandler = { _ in }) {
        print("perform signUp func")
        completion(nil)
        
    }
    
    func signIn(email: String, password: String, completion: @escaping CompletionHandler = { _ in }) {
        print("perform signIN func")
        completion(nil)
    }
    
    // FIXME: - func updateUser
}
