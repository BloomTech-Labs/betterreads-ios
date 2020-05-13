//
//  LibraryController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/11/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

class LibraryController {
    
    /// Holds all the user's books
    var myBooksArray = [UserBook]()
    // FIXME: change the userID to not be hard coded later
    let baseUrl = URL(string: "https://api.readrr.app/api/131/library")!

    init() {
        fetchUserLibrary(with: "token goes here")
    }
    /// Returns all books in user's library
    func fetchUserLibrary(with token: String, completion: @escaping (Error?) -> Void = { _ in }) {
        
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let userId = UserController.shared.user?.id {
            print("userId is \(userId)")
        } else { print("no user id") }
        
        //guard let userId = UserController.shared.authToken else { print("no userId"); return }
        let authorizationTokenTemp = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0IjoxMzEsInJvbGUiOiJ1c2VyIiwiZnVsbE5hbWUiOiJKb3JnZTEyMzQiLCJlbWFpbEFkZHJlc3MiOiJqb3JnZUBnbS5jb20iLCJpbWFnZSI6bnVsbCwiZ29vZ2xlSUQiOm51bGwsImZhY2Vib29rSUQiOm51bGwsImlhdCI6MTU4OTM4MzYyMiwiZXhwIjoxNTg5NDcwMDIyfQ.Z2rjvCt6q9i9G6yneTZ23WPjPkmAI7Fz8_UTxJn7GfY"
        request.addValue(authorizationTokenTemp, forHTTPHeaderField: "Authorization")
        
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("\(toke)", forHTTPHeaderField: "Authorization")
        
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
                //                let listingRepresentations = Array(try jsonDecoder.decode([String: Book].self,
                //                                                                          from: data).values)
                //                /// Go through all listings and returns an array made up of only the user's listings (userId)
                //                /// convert to lowercase first so case doesn't matter
                //                let booksArray = listingRepresentations.filter {
                //                    $0.title.lowercased().contains(term.lowercased())
                //                }
                // NEW
                //print("locationsArray: \(booksArray)")
                self.myBooksArray = booksArray
                print("myBooksArray (\(self.myBooksArray.count) = \(self.myBooksArray)")
                // OLD
                //self.searchResultsArray = listingRepresentations
                //try self.updateListings(with: listingRepresentations)
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
}

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
         case isEbook, language, pageCount, publisher, smallThumbnail, textSnippet, thumbnail, title, webReaderLink, averageRating, isbn10, isbn13, publishedDate
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
//      "thumbnail": "https://books.google.com/books/content?id=OYtkbGl2j0sC&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE71iCzhiNqn9VPT0nlziwmbvWOIa9EVNjEh_O5K95HrEBzKUMvYcL4I7bXYlsZxPM12VP8Fk8et1EZQ7JS5SSGgeMAo9gVChhbT3UuDsHjorVFI286_DiPjFrRQKcw7n5Fjns1AR&source=gbs_api",
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
     "thumbnail": "https://books.google.com/books/content?id=OYtkbGl2j0sC&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE71iCzhiNqn9VPT0nlziwmbvWOIa9EVNjEh_O5K95HrEBzKUMvYcL4I7bXYlsZxPM12VP8Fk8et1EZQ7JS5SSGgeMAo9gVChhbT3UuDsHjorVFI286_DiPjFrRQKcw7n5Fjns1AR&source=gbs_api",
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
     "thumbnail": "https://books.google.com/books/content?id=kotPYEqx7kMC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
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
     "thumbnail": "https://books.google.com/books/content?id=CCiZnVG1j4cC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
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
     "thumbnail": "https://books.google.com/books/content?id=SGAZdjNfruYC&printsec=frontcover&img=1&zoom=1&source=gbs_api",
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
     "thumbnail": "https://books.google.com/books/content?id=kcsqGna7fBIC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
     "pageCount": 768,
     "dateStarted": null,
     "dateEnded": null,
     "dateAdded": "2020-05-11T16:49:46.817Z",
     "userRating": null
   }
 ]
 */
