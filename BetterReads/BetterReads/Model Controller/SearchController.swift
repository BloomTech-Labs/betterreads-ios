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

    // MARK: - Properties

    /// https://readrr-heroku-test.herokuapp.com/search
    let baseUrl = URL(string: "https://readrr-heroku-test.herokuapp.com/search")!

    /// Holds books that are returned from search
    var searchResultBooks: [Book] = []

    // MARK: - Networking methods

    /// Fetches image at URL passed in and returns a UIImage (returns placeholder image if none exists)
    static func fetchImage(with urlString: String, completion: @escaping (UIImage?) -> Void = { _ in }) {

        /// If there are any errors fetching an image, this image is returned instead
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
        // We added an extension to URL (in Helpers.swift) that can return the same URL using https, but we
        // left this old version in just because we didn't have time to switch it out (too risky at the time)

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

    /// Takes in a String, POSTs it to our database,
    /// receives top 10 results based on that search (searches by title only currently).
    /// Heroku databases go to "sleep" after while, so sometimes the first search
    /// you make in a while will take up to 10 seconds, but the rest are less than 2 seconds.
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
                let booksArray = try jsonDecoder.decode(SearchResult.self, from: data)
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

    /// Fetches array of NYT Best Sellers (fiction ones), and returns that array.
    /// WARNING! NYT books can NOT be added to library though.
    /// (NYT added last week of Labs, and returns different Book model than other recommendations).
    /// This method isn't in LibraryController simply for returning unusable books and LibraryController being too big
    static func fetchNYTBestSellers(completion: @escaping ([Book]?) -> Void = { _ in }) {
        ///https://dsapi.readrr.app/nyt/fiction
        let requestUrl = URL(string: "https://dsapi.readrr.app/nyt/fiction")!
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching NYT: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let data = data else {
                print("No data return by data task in fetchNYT")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                print("Data = \(data)")
                let recommendation = try jsonDecoder.decode(Recommendation.self, from: data)
                let bestSellersArray = recommendation.recommendations
                DispatchQueue.main.async {
                    completion(bestSellersArray)
                }
            } catch {
                print("Error decoding NYT \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
