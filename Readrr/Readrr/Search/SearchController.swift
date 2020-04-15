//
//  SearchController.swift
//  Readrr
//
//  Created by Jorge Alvarez on 4/15/20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import Alamofire

class SearchController {
    
    static func searchByTitle(title: String, completionHandler: @escaping (AFDataResponse<Data?>) -> Void) {
        
        guard let url = Keys.baseURL?.appendingPathComponent("api/books").appendingPathComponent(title) else { return }
    
        var searchUrl = URLComponents(url: url, resolvingAgainstBaseURL: true)
        searchUrl?.queryItems = [URLQueryItem(name: "title", value: title)]
        
        // validate = range is 200 - 300 (success)
        AF.request(searchUrl?.url ?? url, method: .get).validate().response { (response) in
            completionHandler(response)
        }
        
    }
    
}
