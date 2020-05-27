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
    //var allCustomShelvesArray = [[UserBook]]()
    
    /// Array of Books based on recommendations from a random user shelf
    var recommendationsForRandomShelf: [Book]?
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
        print("new init")
        fetchUserLibrary()
    }

    // MARK: - Networking

    /// Returns an array of Books based on books posted to database
    func fetchRecommendedBooks(completion: @escaping (Error?) -> Void = { _ in }) {
        print("called fetchRecBooks")
        guard let userId = userId,
            let token = token else { print("no token/id"); return }
        ///https://api.readrr.app/api/131/recommendations
        let requestUrl = baseUrl.appendingPathComponent("\(userId)/recommendations")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        // FIXME: pick random index between 0 and total user shelves count
        // FIXME: what if shelf exists but is empty?
        let body = BooksForRecommendations(books: userShelves[0].books ?? [])
        //print("body = \(body)")
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            request.httpBody = try jsonEncoder.encode(body)
//            if let possibleJsonSent = request.httpBody {
//                let jsonSent = try JSONSerialization.jsonObject(with: possibleJsonSent, options: .allowFragments)
//                print("JSON SENT = \(jsonSent)")
//            }
        } catch {
            print("Error encoding json body: \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching recommendations for shelf: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                print("No data return by data task in fetchRecs")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                print("Data! = \(data)")
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print("JSON response = \(json)")
                let recommendationResult = try jsonDecoder.decode(RecommendationsResult.self, from: data)
                self.recommendationsForRandomShelf = recommendationResult.recommendations.recommendations
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing recs for random shelf! \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }

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
                let allCustomShelvesWithBooks = try jsonDecoder.decode([UserShelf].self, from: data)
                // clear whole array to not get duplicates
                self.userShelves = []
                self.userShelves = allCustomShelvesWithBooks
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

        print("fetchUserLibrary")
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
                // clear whole array to not get duplicates
                self.allShelvesArray = []

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

                DispatchQueue.main.async {
                    print("Finished fetching Library")
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

    /// Add's Book to user's library (just to My Books, readingStatus = 0, favorite = false)
    func addBookToLibrary(book: Book, status: Int, completion: @escaping (Error?) -> Void = { _ in }) {

        print("addBookToLibrary")
        guard let userId = UserController.shared.user?.userID else {
            print("no user id")
            completion(nil)
            return
        }

        var requestUrl = baseUrl.appendingPathComponent("\(userId)")
        requestUrl = requestUrl.appendingPathComponent("library")
        print("requestUrl = \(requestUrl)")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let unwrappedToken = UserController.shared.authToken else {
            print("No token")
            completion(nil)
            return
        }

        request.addValue(unwrappedToken, forHTTPHeaderField: "Authorization")

        let body = PostBookStruct(book: book, readingStatus: status, favorite: false)
        //print("body = \(body)")
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(body)
            //            if let possibleJsonSent = request.httpBody {
            //                let jsonSent = try JSONSerialization.jsonObject(with: possibleJsonSent, options: .allowFragments)
            //                print("JSON SENT = \(jsonSent)")
            //            }
        } catch {
            print("Error encoding json body: \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }

        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print("CODE: \(response.statusCode)")
                completion(error)
                return
            }
            
            if let error = error {
                print("Error POSTING book: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            completion(nil)
            print("POST book success")
        }.resume()
    }
}
