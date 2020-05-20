//
//  BetterReadsTests.swift
//  BetterReadsTests
//
//  Created by Ciara Beitel on 5/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import XCTest
@testable import BetterReads

class BetterReadsTests: XCTestCase {
    var searchController = SearchController()
    let emptyStarImage = UIImage(named: "Stars_Chunky-AltoGray")
    let halfFilledStarImage = UIImage(named: "Stars_Chunky-AltoGray-LeftHalf")
    let fullStarImage = UIImage(named: "Stars_Chunky-DoveGray")
    func testSearchEndpoint() {
        XCTAssertEqual("https://readrr-heroku-test.herokuapp.com/search", "\(searchController.baseUrl)")
    }
    func testDecodingSearchResults() {
        do {
            let dataURL = Bundle.main.url(forResource: "FakeSearchResults", withExtension: "json")!
            let data = try Data(contentsOf: dataURL)
            let result = Array(try JSONDecoder().decode([String: Book].self, from: data).values)
            XCTAssertNoThrow(result)
        } catch {
            NSLog("Error")
        }
        do {
            let badDataURL = Bundle.main.url(forResource: "BadFakeSearchResults", withExtension: "json")!
            let badData = try Data(contentsOf: badDataURL)
            let badDataResult = Array(try JSONDecoder().decode([String: Book].self, from: badData).values)
            XCTAssertThrowsError(badDataResult)
        } catch {
            NSLog("Error")
        }
    }
    func testZeroStarRating() {
        let zeroStarBook = Book(authors: ["Ms. Writer"],
                                categories: ["Fiction"],
                                itemDescription: "Description",
                                googleID: "123",
                                isEbook: false,
                                language: "English",
                                pageCount: 33,
                                publisher: "A press",
                                smallThumbnail: "",
                                textSnippet: "Text snippet",
                                thumbnail: "",
                                title: "Test Title",
                                webReaderLink: "",
                                averageRating: 0.00,
                                isbn10: "", isbn13: "",
                                publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = zeroStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testHalfStarRating() {
        let halfStarBook = Book(authors: ["Ms. Writer"],
                                categories: ["Fiction"],
                                itemDescription: "Description",
                                googleID: "123",
                                isEbook: false,
                                language: "English",
                                pageCount: 33,
                                publisher: "A press",
                                smallThumbnail: "",
                                textSnippet: "Text snippet",
                                thumbnail: "",
                                title: "Test Title",
                                webReaderLink: "",
                                averageRating: 0.50,
                                isbn10: "", isbn13: "",
                                publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = halfStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, halfFilledStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
}
