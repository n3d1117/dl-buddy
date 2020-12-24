//
//  UtilitiesTests.swift
//  dl-buddyTests
//
//  Created by ned on 19/12/20.
//

import XCTest
@testable import dl_buddy

class UtilitiesTests: XCTestCase {

    // MARK: - Test String extensions

    func testIsValidURLStringExtension() {
        let realUrl = "https://apple.com/"
        let realUrl2 = "apple.com/"
        let realUrl3 = "https://app.le/file.zip"
        XCTAssertTrue(realUrl.isValidURL)
        XCTAssertTrue(realUrl2.isValidURL)
        XCTAssertTrue(realUrl3.isValidURL)
    }

    func testIsNotValidURLStringExtension() {
        let fakeUrl1 = ""
        let fakeUrl2 = " "
        let fakeUrl3 = "not a real url"
        XCTAssertFalse(fakeUrl1.isValidURL)
        XCTAssertFalse(fakeUrl2.isValidURL)
        XCTAssertFalse(fakeUrl3.isValidURL)
    }
}
