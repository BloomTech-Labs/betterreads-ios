//
//  Recommendation.swift
//  BetterReads
//
//  Created by Ciara Beitel on 5/12/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

struct RecommendationsResult: Codable {
    let message: String
    let recommendations: Recommendation
}

struct Recommendation: Codable {
    let basedOn: String
    let recommendations: [Book]
    enum CodingKeys: String, CodingKey {
        case basedOn = "based_on"
        case recommendations
    }
}
