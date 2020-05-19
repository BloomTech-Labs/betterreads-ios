//
//  LibraryController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/11/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

class LibraryController {

    /// Holds all of the user's shelves
    var allShelvesArray = [[UserBook]]()

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
    
    var token: String? {
        guard let unwrappedToken = UserController.shared.authToken else {
            return nil
        }
        return unwrappedToken
    }
    
    var userId: Int? {
        guard let unwrappedUserId = UserController.shared.user?.userID else {
            return nil
        }
        return unwrappedUserId
    }

    init() {
        fetchUserLibrary()
    }

    private func fetchCustomShelves(completion: @escaping (Error?) -> Void = { _ in }) {
        guard let userId = userId,
            let token = token else { return }
        //https://api.readrr.app/api/shelves/user/131
        let requestUrl = baseUrl.appendingPathComponent("shelves/user/\(userId)")
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

struct UserShelf: Codable {
    let shelfId: Int?
    let userId: Int?
    let shelfName: String?
    let isPrivate: Bool?
}
/*
 [
   {
     "shelfId": 76,
     "userId": 131,
     "shelfName": "Philosophy",
     "isPrivate": null
   },
   {
     "shelfId": 77,
     "userId": 131,
     "shelfName": "Fire Stuff",
     "isPrivate": null
   },
   {
     "shelfId": 81,
     "userId": 131,
     "shelfName": "Sci-fi",
     "isPrivate": null
   }
 ]
 */

/*
 struct Book: Codable {
     let authors: [String]?
     let categories: [String]?
     let itemDescription: String?
     let googleID: String? // wasn't optional
     let isEbook: Bool? // wasn't optional
     let language: String? // used to be Language and not optional
     let pageCount: Int?
     let publisher: String? // wasn't optional
     let smallThumbnail: String? // wasn't optional
     let textSnippet: String?
     let thumbnail: String? // wasn't optional
     let title: String? // wasn't optional
     let webReaderLink: String? // wasn't optional
     let averageRating: Double?
     let isbn10, isbn13, publishedDate: String?

     enum CodingKeys: String, CodingKey {
         case authors, categories
         case itemDescription = "description"
         case googleID = "googleId"
         case isEbook, language, pageCount, publisher, smallThumbnail,
                textSnippet, thumbnail, title, webReaderLink,
                averageRating, isbn10, isbn13, publishedDate
     }
 }
 */

struct UserBook: Codable {
    let userBooksId: Int?
    let bookId: Int?
    let googleId: String?
    let title: String?
    let authors: String? // could this be an array?
    let readingStatus: Int?
    let favorite: Bool?
    let categories: String?
    let thumbnail: String?
    let pageCount: Int?
    let dateStarted: String? // DATETIME
    let dateEnded: String? // DATETIME
    let dateAdded: String? // DATETIME
    let userRating: Double? // DECIMAL
    // example response
//    {
//      "userBooksId": 365,
//      "bookId": 315,
//      "googleId": "OYtkbGl2j0sC",
//      "title": "Fahrenheit 451",
//      "authors": "Ray Bradbury",
//      "readingStatus": 1,
//      "favorite": false,
//      "categories": "Fiction / Classics,Fiction / Science Fiction / General,Fiction / Media Tie-In",
//      "thumbnail": "https://books.google.com/books/content?id=_api",
//      "pageCount": 208,
//      "dateStarted": null,
//      "dateEnded": null,
//      "dateAdded": "2020-05-11T18:50:21.337Z",
//      "userRating": null
//    }
}

// Example library response
/*
 [
   {
     "userBooksId": 365,
     "bookId": 315,
     "googleId": "OYtkbGl2j0sC",
     "title": "Fahrenheit 451",
     "authors": "Ray Bradbury",
     "readingStatus": 1,
     "favorite": false,
     "categories": "Fiction / Classics,Fiction / Science Fiction / General,Fiction / Media Tie-In",
     "thumbnail": "https://books.google.com/books/content?id=OY1AR&source=gbs_api",
     "pageCount": 208,
     "dateStarted": null,
     "dateEnded": null,
     "dateAdded": "2020-05-11T18:50:21.337Z",
     "userRating": null
   },
   {
     "userBooksId": 364,
     "bookId": 314,
     "googleId": "kotPYEqx7kMC",
     "title": "1984",
     "authors": "George Orwell",
     "readingStatus": 3,
     "favorite": false,
     "categories": "{\"Fiction\"}",
     "thumbnail": "https://books.google.com/books/content?id=kocurl&source=gbs_api",
     "pageCount": 648,
     "dateStarted": null,
     "dateEnded": null,
     "dateAdded": "2020-05-11T18:44:50.051Z",
     "userRating": null
   },
   {
     "userBooksId": 363,
     "bookId": 313,
     "googleId": "CCiZnVG1j4cC",
     "title": "Mortality",
     "authors": "Christopher Hitchens",
     "readingStatus": 3,
     "favorite": false,
     "categories": "{\"Biography & Autobiography\"}",
     "thumbnail": "https://books.google.com/books/content?id=CC=curl&source=gbs_api",
     "pageCount": 128,
     "dateStarted": null,
     "dateEnded": null,
     "dateAdded": "2020-05-11T18:43:03.441Z",
     "userRating": null
   },
   {
     "userBooksId": 362,
     "bookId": 312,
     "googleId": "SGAZdjNfruYC",
     "title": "Animal Farm",
     "authors": "George Orwell",
     "readingStatus": 2,
     "favorite": false,
     "categories": "{\"Fiction\"}",
     "thumbnail": "https://books.google.com/books/content?id=SG&zoom=1&source=gbs_api",
     "pageCount": 140,
     "dateStarted": null,
     "dateEnded": null,
     "dateAdded": "2020-05-11T17:17:20.813Z",
     "userRating": null
   },
   {
     "userBooksId": 361,
     "bookId": 311,
     "googleId": "kcsqGna7fBIC",
     "title": "Breaking Dawn",
     "authors": "Stephenie Meyer",
     "readingStatus": 1,
     "favorite": false,
     "categories": "{\"Young Adult Fiction\"}",
     "thumbnail": "https://books.google.com/books/content?id=kc=curl&source=gbs_api",
     "pageCount": 768,
     "dateStarted": null,
     "dateEnded": null,
     "dateAdded": "2020-05-11T16:49:46.817Z",
     "userRating": null
   }
 ]
 */
