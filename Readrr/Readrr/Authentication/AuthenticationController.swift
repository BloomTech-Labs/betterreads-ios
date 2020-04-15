//
//  AuthenticationController.swift
//  Readrr
//
//  Created by Alexander Supe on 4/14/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

class AuthenticationController {
    static func signUp(with name: String, email: String, password: String, completion: @escaping (AFDataResponse<Data?>) -> Void) {
        guard let url = Keys.baseURL?.appendingPathComponent("/api/auth/signup") else { return }
        let user = User(fullName: name, emailAddress: email, password: password)
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).validate().response { (response) in
            completion(response)
            switch response.result {
            case .success(let data):
                KeychainSwift.shared.set(email, forKey: "email")
                KeychainSwift.shared.set(name, forKey: "name")
                KeychainSwift.shared.set(password, forKey: "password")
                debugPrint(data as Any)
            case .failure(let error):
                debugPrint(error)
                //check for error (repeat)
            }
        }
    }
    
    static func signIn(with email: String, password: String, completion: @escaping (AFDataResponse<Data?>) -> Void) {
        guard let url = Keys.baseURL?.appendingPathComponent("/api/auth/signin") else { return }
        let user = User(emailAddress: email, password: password)
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).validate().response { (response) in
            completion(response)
            switch response.result {
            case .success(let data):
                KeychainSwift.shared.set(email, forKey: "email")
                KeychainSwift.shared.set(password, forKey: "password")
                // TODO: Add name from response
                debugPrint(data as Any)
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }
}
