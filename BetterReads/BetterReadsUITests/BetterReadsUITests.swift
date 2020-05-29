//
//  BetterReadsUITests.swift
//  BetterReadsUITests
//
//  Created by Ciara Beitel on 5/20/20.
//  Copyright © 2020 Labs23. All rights reserved.
//

import XCTest

class BetterReadsUITests: XCTestCase {
    private var app: XCUIApplication {
        return XCUIApplication()
    }
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    func testSignInScreenShowing() {
        let signInSegBtn = app.firstMatch.scrollViews.segmentedControls.buttons["Sign in"]
        let firstLabel = app.staticTexts["Email address label"]
        if signInSegBtn.isSelected {
            XCTAssertTrue(firstLabel.exists)
        }
    }
    func testSignUpScreenShowing() {
        let signUpSegBtn = app.firstMatch.scrollViews.segmentedControls.buttons["Sign up"]
        signUpSegBtn.tap()
        let firstLabel = app.staticTexts["Full name label"]
        if signUpSegBtn.isSelected {
            XCTAssertTrue(firstLabel.exists)
        }
    }
    func testPasswordsMatch() {
        let elementsQuery = app.scrollViews.otherElements
        let nextButton = app.buttons["Next:"]
        let doneButton = app.buttons["Done"]
        elementsQuery.buttons["Sign up"].tap()
        elementsQuery.textFields["Jane Smith"].tap()
        let shiftKey = app.buttons["shift"]
        let shiftAKey = app.keys["A"]
        let aKey = app.keys["a"]
        let atSignKey = app.keys["@"]
        let periodKey = app.keys["."]
        let cKey = app.keys["c"]
        let oKey = app.keys["o"]
        let mKey = app.keys["m"]
        let bKey = app.keys["b"]
        let moreKey = app.keys["more"]
        let oneKey = app.keys["1"]
        let twoKey = app.keys["2"]
        shiftKey.tap()
        shiftAKey.tap()
        aKey.tap()
        nextButton.tap()
        aKey.tap()
        aKey.tap()
        atSignKey.tap()
        aKey.tap()
        aKey.tap()
        periodKey.tap()
        cKey.tap()
        oKey.tap()
        mKey.tap()
        nextButton.tap()
        aKey.tap()
        aKey.tap()
        bKey.tap()
        bKey.tap()
        cKey.tap()
        cKey.tap()
        moreKey.tap()
        oneKey.tap()
        doneButton.tap()
        aKey.tap()
        aKey.tap()
        bKey.tap()
        bKey.tap()
        cKey.tap()
        cKey.tap()
        moreKey.tap()
        twoKey.tap()
        doneButton.tap()
        elementsQuery.containing(.image, identifier: "BetterReads-Logo_Orange").element.swipeUp()
        let errorStateMessage = elementsQuery
            .staticTexts["Confirm password error message"]
        XCTAssertTrue(errorStateMessage.exists)
    }
    func testForgotPasswordModalShows() {
        app.scrollViews.otherElements.buttons["Forgot password button"].tap()
        let downArrow = app.buttons["Down arrow button"]
        XCTAssertTrue(downArrow.exists)
    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
                // Tested on May 20, 2020 at 6:21pm EDT
                // Average launch = 1.003 secs
                // Tested on May 29, 2020 at 4:51pm EDT
                // Average launch = 1.129 s
            }
        }
    }
}
