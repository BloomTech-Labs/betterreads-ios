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
    case noUser
}

class UserController {
    typealias JWT = String
    private var baseURL = URL(string: "https://api.readrr.app/api")!
    var authToken: JWT?
    var user: User?
    var isNewUser: Bool?
    var recommendedBooks: [Book]?
    static let shared = UserController()
    static let sharedLibraryController = LibraryController()
    private init() { }
    typealias CompletionHandler = (Error?) -> Void
    // MARK: - Sign Up
    func signUp(fullName: String,
                emailAddress: String,
                password: String,
                completion: @escaping CompletionHandler = { _ in }) {
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
                    switch response.result {
                    case .success(let value):
                        let jsonData = JSON(value)
                        let authToken = jsonData["token"].stringValue
                        self.authToken = authToken
                        self.user = User(userID: Int(), fullName: Name(fullName: fullName), emailAddress: emailAddress)
                        completion(nil)
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
    // MARK: - Sign In
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
                    switch response.result {
                    case .success(let value):
                        let jsonData = JSON(value)
                        guard let authToken = jsonData["token"].string else { return completion(NetworkError.noDecode) }
                        self.authToken = authToken
                        do {
                            let jwt = try decode(jwt: authToken)
                            let fullNameClaim = jwt.claim(name: "fullName")
                            // get the id from the token NOT the user
                            let idClaim = jwt.claim(name: "subject")
                            guard let fullName = fullNameClaim.string,
                                let userID = idClaim.integer else {
                                    return completion(NetworkError.otherError) }
                            self.user = User(userID: userID,
                                             fullName: Name(fullName: fullName),
                                             emailAddress: emailAddress)
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
    // MARK: - Forgot Password Email
    func forgotPasswordEmail(emailAddress: String, completion: @escaping CompletionHandler = { _ in }) {
        let forgotPasswordEmailURL = baseURL.appendingPathComponent("auth")
        .appendingPathComponent("reset").appendingPathComponent("requestreset")
        let parameters = ["email": emailAddress]
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        AF.request(forgotPasswordEmailURL,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).responseJSON { response in
                    switch response.result {
                    case .success:
                        completion(nil)
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
    // MARK: - Recommendations
    func getRecommendations(completion: @escaping CompletionHandler = { _ in }) {
        guard let user = user,
            let authToken = authToken else { return completion(NetworkError.otherError) }
        let getRecommendationsURL = baseURL.appendingPathComponent("\(user.userID)")
            .appendingPathComponent("recommendations")
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": authToken
        ]
        AF.request(getRecommendationsURL,
                   method: .get,
                   headers: headers).response { response in
                    switch response.result {
                    case .success(let value):
                        guard let data = value else { return completion(NetworkError.badData) }
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.dateDecodingStrategy = .iso8601
                        do {
                            let recommendationsDecoded = try jsonDecoder.decode(RecommendationsResult.self, from: data)
                            self.recommendedBooks = recommendationsDecoded.recommendations.recommendations
                            completion(nil)
                        } catch {
                            print("Error decoding recommended books \(error)")
                            completion(NetworkError.noDecode)
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(NetworkError.otherError)
                    }
        }
    }
}
