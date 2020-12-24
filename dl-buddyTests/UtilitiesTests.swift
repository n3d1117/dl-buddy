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

    // MARK: - Test Int64 extensions

    func testHumanReadableFileSize() {
        let fileSize: Int64 = 432543432
        XCTAssertEqual(fileSize.humanReadable, "432,5 MB")
    }

    // MARK: - Test Progress extensions

    func testProgressAsString() {
        let progress = Progress()
        progress.completedUnitCount = 327646372
        progress.totalUnitCount = 4676743973
        XCTAssertEqual(progress.asString, "Downloading 327,6 MB of 4,68 GB (7%)")
    }

    // MARK: - Test Array extensions

    func testArrayDifference() {
        let first = ["Joe", "Paul", "Frank", "Mark"]
        let second = ["Paul", "Frank"]

        let difference = first.difference(from: second)

        XCTAssertEqual(difference.sorted(), ["Joe", "Mark"].sorted())
    }

    // MARK: - Test Date extensions

    func testDateHumanReadable() {
        let date = Date(timeIntervalSince1970: 1605623619)
        XCTAssertEqual(date.humanReadable, "17 november 2020 at 15:33")
    }

    func testDateIntervalHumanReadable() {
        let date = Date(timeIntervalSince1970: 1605623619) // 17 nov
        let date2 = Date(timeIntervalSince1970: 1608820419) // 24 dec
        XCTAssertEqual(date.localizedInterval(from: date2), "1 month ago")
    }
}
