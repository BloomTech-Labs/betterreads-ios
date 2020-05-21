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
        let firstLabel = app.staticTexts["Email"]
        if signInSegBtn.isSelected {
            XCTAssertTrue(firstLabel.exists)
        }
    }
    func testSignUpScreenShowing() {
        let signUpSegBtn = app.firstMatch.scrollViews.segmentedControls.buttons["Sign up"]
        signUpSegBtn.tap()
        let firstLabel = app.staticTexts["Full name"]
        if signUpSegBtn.isSelected {
            XCTAssertTrue(firstLabel.exists)
        }
    }
    func testPasswordsMatch() {
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.buttons["Sign up"].tap()
        let fullNameTF = elementsQuery.textFields["Jane Smith"]
        fullNameTF.tap()
        fullNameTF.typeText("Test User")
        let nextButton = app.buttons["Next:"]
        nextButton.tap()
        app.typeText("aa@aa.com")
        nextButton.tap()
        app.typeText("aabbcc1")
        let betterreadsLogoOrangeElement = scrollViewsQuery.otherElements
            .containing(.image, identifier: "BetterReads-Logo_Orange").element
        betterreadsLogoOrangeElement.swipeUp()
        let confirmPasswordSecureTextField = elementsQuery.secureTextFields["Confirm password"]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("aabbcc2")
        app.buttons["Done"].tap()
        let errorStateMessage = elementsQuery
            .staticTexts["Passwords do not match."]
        XCTAssertTrue(errorStateMessage.exists)
    }
    func testForgotPasswordModalShows() {
        app.scrollViews.otherElements.buttons["Forgot your password?"].tap()
        let downArrow = app.buttons["Down Arrow Button"]
        XCTAssertTrue(downArrow.exists)
    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
                // Tested on May 20, 2020 at 6:21pm EDT
                // Average launch = 1.003 secs
            }
        }
    }
}
