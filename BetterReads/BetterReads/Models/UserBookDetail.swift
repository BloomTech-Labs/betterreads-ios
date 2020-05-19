//
//  UserBookDetail.swift
//  BetterReads
//
//  Created by Jorge Alvarez on 5/19/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import Foundation

/*
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
 }

 */

struct UserBookDetail: Codable {
  let bookId: Int?
  let userBooksId: Int?
  let googleId: String?
  let isbn10: String?
  let isbn13: String?
  let readingStatus: Int?
  let dateStarted: String?
  let dateEnded: String?
  let dateAdded: String?
  let favorite: Bool?
  let userRating: Double?
  let title: String?
  let authors: String?
  let categories: String?
  let thumbnail: String?
  let pageCount: Int?
  let publisher: String?
  let publishedDate: String?
  let description: String?
  let textSnippet: String?
  let language: String?
  let webReaderLink: String?
  let isEbook: Bool?
  let averageRating: String?
}
