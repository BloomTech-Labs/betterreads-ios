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

    /// https://readrr-heroku-test.herokuapp.com/search
    let baseUrl = URL(string: "https://readrr-heroku-test.herokuapp.com/search")!

    /// Holds books that are returned from search
    var searchResultBooks: [Book] = []

    /// Fetches image at url passed in and returns a uimage (place holder image if none exists)
    static func fetchImage(with urlString: String, completion: @escaping (UIImage?) -> Void = { _ in }) {

        let defaultImage = UIImage().chooseDefaultBookImage()

        // This is to remove the curl on the bottom of some book images
        let stringWithoutCurl = urlString.replacingOccurrences(of: "&edge=curl", with: "")

        guard let url = URL(string: stringWithoutCurl) else {
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

        //print("secureUrl now = \(secureUrl)")
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
                print("locationsArray: \(booksArray)")
                self.searchResultBooks = booksArray.items
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
