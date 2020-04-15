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
    static func signUp(with name: String? = nil, email: String, password: String, completion: @escaping (AFResult<Any>) -> Void) {
        let login = (name == nil)
        guard let url = Keys.baseURL?.appendingPathComponent(login ? "/api/auth/signin" : "/api/auth/signup") else { return }
        let user = User(fullName: name, emailAddress: email, password: password)
        
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).validate().responseJSON { (response) in
            completion(response.result)
            switch response.result {
            case .success(let data):
                KeychainSwift.shared.set(email, forKey: "email")
                KeychainSwift.shared.set(password, forKey: "password")
                if let name = name {
                    KeychainSwift.shared.set(name, forKey: "name")
                } else if let dict = data as? [String: Any],
                    let user = dict["user"] as? [String: Any],
                    let name = user["fullName"] as? String {
                    KeychainSwift.shared.set(name, forKey: "name")
                }
            case .failure:
                break
            }
        }
    }
}
