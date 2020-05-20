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
    override func tearDownWithError() throws {
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
//    func testPasswordsMatch() {
//        let signUpSegBtn = app.firstMatch.scrollViews.segmentedControls.buttons["Sign up"]
//        signUpSegBtn.tap()
//        let passwordTF = app.secureTextFields.firstMatch
//        let confirmTF = app.secureTextFields.element(boundBy: 1)
//        passwordTF.tap()
//        passwordTF.typeText("abcde123")
//        passwordTF.typeText("\n")
//        confirmTF.tap()
//        confirmTF.typeText("abcde123")
//        confirmTF.typeText("\n")
//    }
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
            // Tested on May 20, 2020 at 6:21pm EDT
            // Average launch = 1.003 secs
        }
    }
}
