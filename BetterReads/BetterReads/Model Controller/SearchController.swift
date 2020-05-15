//
//  SearchController.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 4/23/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation
import UIKit

class SearchController {
    let baseUrl = URL(string: "https://readrr-heroku-test.herokuapp.com/search")!
    /// Holds books that are returned from search
    var searchResultBooks: [Book] = []
    // FIXME: default image should be a custom image for no book cover
    /// Fetches image at url passed in and returns a uimage (place holder image if none exists)
    static func fetchImage(with urlString: String, completion: @escaping (UIImage?) -> Void = { _ in }) {
        let defaultImage = UIImage(systemName: "book.fill")
        print("called fetchImage with url: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("cant make url from passed in string")
            completion(defaultImage)
            return
        }
        let http = url
        let urlComponents = URLComponents(url: http, resolvingAgainstBaseURL: false)
        guard let comps = urlComponents else {
            print("cant make urlComponents")
            completion(defaultImage)
            return
        }
        var components = comps
        components.scheme = "https"
        guard let secureUrl = components.url else {
            print("cant make secureUrl from http")
            completion(defaultImage)
            return
        }
        print("secureUrl now = \(secureUrl)")
        URLSession.shared.dataTask(with: secureUrl) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(defaultImage)
                return
            }
            let imageToReturn = UIImage(data: data)
            completion(imageToReturn)
        }.resume()
    }
    /*
         
         URLSession.shared.dataTask(with: url) { (data, _, error) in
             if let error = error {
                 NSLog("Error fetching image: \(error)")
                 return
             }
             
             guard let data = data else {
                 NSLog("No data returned from data task")
                 completion(nil)
                 return
             }
             
             let image = UIImage(data: data)
             
             completion(image)
         }.resume()
     }
     */
    /// Gets ALL Listings from the server. Sets searchResultsArray to listings that contain term
    func searchBook(with term: String, completion: @escaping (Error?) -> Void = { _ in }) {
        var request = URLRequest(url: baseUrl)
        let body = TypeQuery(type: "search", query: term)
        request.httpMethod = "POST"
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            request.httpBody = try jsonEncoder.encode(body)
        } catch {
            print("Error encoding json body \(body): \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }
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
                let booksArray = try jsonDecoder.decode(SearchResult.self, from: data)
//                let listingRepresentations = Array(try jsonDecoder.decode([String: Book].self,
//                                                                          from: data).values)
//                /// Go through all listings and returns an array made up of only the user's listings (userId)
//                /// convert to lowercase first so case doesn't matter
//                let booksArray = listingRepresentations.filter {
//                    $0.title.lowercased().contains(term.lowercased())
//                }
                // NEW
                print("locationsArray: \(booksArray)")
                self.searchResultBooks = booksArray.items
                // OLD
                //self.searchResultsArray = listingRepresentations
                //try self.updateListings(with: listingRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing searched books \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }

        }.resume()
    }
}

/*
 //
 //  ReservationController.swift
 //  5thWheelRV
 //
 //  Created by Jorge Alvarez on 3/5/20.
 //  Copyright © 2020 Jorge Alvarez. All rights reserved.
 //

 import Foundation
 import CoreData

 class ReservationController {

     typealias CompletionHandler = (Error?) -> Void

     var reservationsArray: [Reservation] = []
     var searchResultsArray: [ListingRepresentation] = []

     init() {
         fetchUsersReservations()
     }

     /// Gets all listings belonging to signed in user (RVOwner)
     func fetchUsersReservations(completion: @escaping CompletionHandler = { _ in }) {
         var requestUrl = baseUrl.appendingPathComponent("reservations")
         requestUrl = requestUrl.appendingPathExtension("json")

         URLSession.shared.dataTask(with: requestUrl) { (data, _, error) in

             if let error = error {
                 print("Error fetching user reservations: \(error)")
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
                 let userReservations = Array(try jsonDecoder.decode([String: Reservation].self,
                                                                           from: data).values)

                 /// Go through all listings and returns an array made up of only the user's listings (userId)
                 let reserves = userReservations.filter { $0.userId == globalUser.identifier }
                 print("userListings = \(reserves)")
                 self.reservationsArray = reserves

                 DispatchQueue.main.async {
                     completion(nil)
                 }
             } catch {
                 print("Error decoding or storing reservations (fetchUsersReservs RC): \(error)")
                 DispatchQueue.main.async {
                     completion(error)
                 }
             }
         }.resume()
     }

     /// Gets ALL Listings from the server. Sets searchResultsArray to listings that contain term
     func fetchAllListings(with term: String, completion: @escaping CompletionHandler = { _ in }) {
         // OLD
         //let requestUrl = baseUrl.appendingPathExtension("json")
         // NEW
         var requestUrl = baseUrl.appendingPathComponent("listings")
         requestUrl = requestUrl.appendingPathExtension("json")

         URLSession.shared.dataTask(with: requestUrl) { (data, _, error) in

             if let error = error {
                 print("Error fetching listings: \(error)")
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
                 let listingRepresentations = Array(try jsonDecoder.decode([String: ListingRepresentation].self,
                                                                           from: data).values)
                 /// Go through all listings and returns an array made up of only the user's listings (userId)
                 /// convert to lowercase first so case doesn't matter
                 let locationsArray = listingRepresentations.filter {
                     $0.location.lowercased().contains(term.lowercased())
                 }
                 // NEW
                 print("locationsArray: \(locationsArray)")
                 self.searchResultsArray = locationsArray
                 // OLD
                 //self.searchResultsArray = listingRepresentations
                 //try self.updateListings(with: listingRepresentations)
                 DispatchQueue.main.async {
                     completion(nil)
                 }
             } catch {
                 print("Error decoding or storing listing representations (fetchAllListings ResControl): \(error)")
                 DispatchQueue.main.async {
                     completion(error)
                 }
             }

         }.resume()
     }

     /// Send a created reservation to the server
     func sendReservationToServer(reservation: Reservation, completion: @escaping CompletionHandler = { _ in }) {

         let uuid = reservation.identifier
         var requestURL = baseUrl.appendingPathComponent("reservations")
         requestURL = requestURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")

         print("requestURL = \(requestURL)")
         // changes back to requestURL
         var request = URLRequest(url: requestURL)
         request.httpMethod = "PUT"

         // Encode data
         do {
             let jsonEncoder = JSONEncoder()
             jsonEncoder.dateEncodingStrategy = .iso8601

             request.httpBody = try jsonEncoder.encode(reservation)
         } catch {
             print("Error encoding listing \(reservation): \(error)")
             DispatchQueue.main.async {
                 completion(error)
             }
             return
         }
         // Send to server
         URLSession.shared.dataTask(with: request) { (_, _, error) in
             if let error = error {
                 print("error putting reservation to server: \(error)")
                 DispatchQueue.main.async {
                     completion(error)
                 }
                 return
             }
             // success
             DispatchQueue.main.async {
                 completion(nil)
             }
         }.resume()
     }
 }

 */
