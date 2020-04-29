//
//  UserController.swift
//  BetterReads
//
//  Created by Ciara Beitel on 4/21/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JWTDecode

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case existingUser
}

class UserController {
    private var baseURL = URL(string: "https://api.readrr.app/api")!
    private var authToken: String? = nil
    private var user: User? = nil
        
    init() {
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    //MARK: - Sign Up
    func signUp(fullName: String, emailAddress: String, password: String, completion: @escaping CompletionHandler = { _ in }) {
        let signUpURL = baseURL.appendingPathComponent("auth")
        .appendingPathComponent("signup")
        let parameters = ["fullName": fullName, "emailAddress": emailAddress, "password": password]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(signUpURL,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        let authToken = jsonData["token"].stringValue
                        self.authToken = authToken
                        self.user = User(fullName: fullName, emailAddress: emailAddress)
                        completion(nil)
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
    
    //MARK: - Sign In
    func signIn(emailAddress: String, password: String, completion: @escaping CompletionHandler = { _ in }) {
        let signInURL = baseURL.appendingPathComponent("auth")
        .appendingPathComponent("signin")
        let parameters = ["emailAddress": emailAddress, "password": password]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(signInURL,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).responseJSON { response in
                    switch (response.result) {
                    case .success(let value):
                        let jsonData = JSON(value)
                        let authToken = jsonData["token"].stringValue
                        self.authToken = authToken
                        do {
                            let jwt = try decode(jwt: authToken)
                            let fullNameClaim = jwt.claim(name: "fullName")
                            guard let fullName = fullNameClaim.string else { return }
                            self.user = User(fullName: fullName, emailAddress: emailAddress)
                            completion(nil)
                        } catch {
                            completion(NetworkError.otherError)
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
}
