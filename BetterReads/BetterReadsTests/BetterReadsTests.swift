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
            let dataURL = Bundle.main.url(forResource: "Testing-GoodFakeSearchResults", withExtension: "json")!
            let data = try Data(contentsOf: dataURL)
            let result = Array(try JSONDecoder().decode([String: Book].self, from: data).values)
            XCTAssertNoThrow(result)
        } catch {
            NSLog("Error")
        }
        do {
            let badDataURL = Bundle.main.url(forResource: "Testing-BadFakeSearchResults", withExtension: "json")!
            let badData = try Data(contentsOf: badDataURL)
            let badDataResult = Array(try JSONDecoder().decode([String: Book].self, from: badData).values)
            XCTAssertThrowsError(badDataResult)
        } catch {
            NSLog("Error")
        }
    }
    func testZeroStarRating() {
        let zeroStarBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 0.00,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = zeroStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testOneHalfStarRating() {
        let oneHalfStarBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 0.50,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = oneHalfStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, halfFilledStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testOneFullStarRating() {
        let oneFullStarBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 1.0,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = oneFullStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testOneAndHalfFullStarRating() {
        let oneAndHalfFullStarBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 1.6,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = oneAndHalfFullStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, halfFilledStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testTwoFullStarRating() {
        let twoFullStarBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 2.1,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = twoFullStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testTwoAndHalfFullStarRating() {
        let twoAndHalfFullStarBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 2.44,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = twoAndHalfFullStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, halfFilledStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testThreeFullStarRating() {
        let threeFullStarsBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 3.0,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = threeFullStarsBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, emptyStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testThreeAndHalfFullStarRating() {
        let threeAndHalfFullStarBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 3.55,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = threeAndHalfFullStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, halfFilledStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testFourFullStarRating() {
        let fourFullStarsBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 3.99,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = fourFullStarsBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, emptyStarImage)
    }
    func testFourAndHalfFullStarRating() {
        let fourAndHalfFullStarBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 4.65,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = fourAndHalfFullStarBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, halfFilledStarImage)
    }
    func testFiveFullStarRating() {
        let fiveFullStarsBook = Book(authors: ["Ms. Writer"], categories: ["Fiction"],
                                itemDescription: "Description", googleID: "123",
                                isEbook: false, language: "English",
                                pageCount: 33, publisher: "A press",
                                smallThumbnail: "", textSnippet: "Text snippet",
                                thumbnail: "", title: "Test Title",
                                webReaderLink: "", averageRating: 5.0,
                                isbn10: "", isbn13: "", publishedDate: "")
        let searchResultView = SearchResultView()
        searchResultView.book = fiveFullStarsBook
        XCTAssertEqual(searchResultView.starsArray[0].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[1].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[2].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[3].image, fullStarImage)
        XCTAssertEqual(searchResultView.starsArray[4].image, fullStarImage)
    }
}
