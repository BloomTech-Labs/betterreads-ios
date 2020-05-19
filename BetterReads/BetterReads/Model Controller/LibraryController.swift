//
//  LibraryController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/11/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

class LibraryController {
    
    // MARK: - Properties

    /// Holds all of the user's shelves
    var allShelvesArray = [[UserBook]]()

    /// An array made up of each custom shelf
    var allCustomShelvesArray = [[UserBook]]()

    /// Holds all of the user's books
    var myBooksArray = [UserBook]()

    /// Holds user books that are "In progress"
    var inProgressBooksArray = [UserBook]()

    /// Holds user books that are "To be read"
    var toBeReadBooksArray = [UserBook]()

    /// Holds user books that are "Finished"
    var finishedBooksArray = [UserBook]()

    /// Holds an array of all the user's custom shelves
    var userShelves = [UserShelf]()

    /// https://api.readrr.app/api
    let baseUrl = URL(string: "https://api.readrr.app/api")!

    /// Returns unwrapped user token from shared UserController
    var token: String? {
        guard let unwrappedToken = UserController.shared.authToken else {
            return nil
        }
        return unwrappedToken
    }

    /// Returns unwrapped user id from shared UserController
    var userId: Int? {
        guard let unwrappedUserId = UserController.shared.user?.userID else {
            return nil
        }
        return unwrappedUserId
    }

    init() {
        fetchUserLibrary()
    }

    // MARK: - Networking

    /// Fetches all custom shelves, and all the books in each
    func fetchCustomShelves(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let userId = userId,
            let token = token else { return }
        ///https://api.readrr.app/api/booksonshelf/user/131/shelves/allbooks
        let requestUrl = baseUrl.appendingPathComponent("booksonshelf/user/\(userId)/shelves/allbooks")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching custom shelves: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                print("No data return by data task in fetchCustomShelves")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                print("Data = \(data)")
                let booksArray = try jsonDecoder.decode([UserShelf].self, from: data)
                self.userShelves = booksArray
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing custom shelves \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }

    /// Returns all books in user's library
    func fetchUserLibrary(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let userId = UserController.shared.user?.userID else {
            print("no user id")
            completion(nil)
            return
        }
        var requestUrl = baseUrl.appendingPathComponent("\(userId)")
        requestUrl = requestUrl.appendingPathComponent("library")
        print("requestUrl = \(requestUrl)")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let unwrappedToken = UserController.shared.authToken else {
            print("No token")
            completion(nil)
            return
        }

        request.addValue(unwrappedToken, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching searched books: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                print("No data return by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                print("Data = \(data)")
                let booksArray = try jsonDecoder.decode([UserBook].self, from: data)

                self.myBooksArray = booksArray
                self.allShelvesArray.append(booksArray)

                self.toBeReadBooksArray = booksArray.filter {
                    $0.readingStatus == 1
                }
                self.allShelvesArray.append(self.toBeReadBooksArray)

                self.inProgressBooksArray = booksArray.filter {
                    $0.readingStatus == 2
                }
                self.allShelvesArray.append(self.inProgressBooksArray)

                self.finishedBooksArray = booksArray.filter {
                    $0.readingStatus == 3
                }
                self.allShelvesArray.append(self.finishedBooksArray)

                print("toBeRead (\(self.toBeReadBooksArray.count))")
                print("inProgress (\(self.inProgressBooksArray.count))")
                print("finished (\(self.finishedBooksArray.count))")
                print("myBooksArray (\(self.myBooksArray.count) = \(self.myBooksArray)")
                print("allShelvesArray (\(self.allShelvesArray.count)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing my books \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }

    /// Takes in a bookId (from a UserBook) and return a corresponding UserBookDetail object
    func fetchBookById(bookId: Int, completion: @escaping (UserBookDetail?) -> Void = { _ in }) {
        print("called fetchBookById with \(bookId)")
        guard let userId = userId,
            let token = token else { return }
        //https://api.readrr.app/api/131/library/314
        let requestUrl = baseUrl.appendingPathComponent("\(userId)/library/\(bookId)")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching Book from bookId: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let data = data else {
                print("No data return by data task in fetchBookById")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                let userBookDetail = try jsonDecoder.decode(UserBookDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(userBookDetail)
                }
            } catch {
                print("Error decoding Book from bookId \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
