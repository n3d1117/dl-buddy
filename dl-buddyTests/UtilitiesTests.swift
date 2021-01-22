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

    // MARK: - Test Codable Progress

    func testCodableProgress() {
        let progress = Progress(totalUnitCount: 3678212)
        progress.completedUnitCount = 2536479

        let codableProgress = CodableProgress(completedUnitCount: 2536479, totalUnitCount: 3678212)

        XCTAssertEqual(codableProgress, progress.codableVersion)
    }

    // MARK: - Test Codable encoding/decoding

    fileprivate func encodeAndDecode<T>(_ value: T) throws -> T where T: Codable {
        let data = try XCTUnwrap(JSONEncoder().encode(value))
        return try XCTUnwrap(JSONDecoder().decode(T.self, from: data))
    }

    func testDownloadStateEncoding() throws {
        let allStates: [DownloadModel.State] = [
            .completed,
            .failed(error: "test error"),
            .downloading(progress: CodableProgress()),
            .paused,
            .unknown
        ]
        try allStates.forEach { state in
            let encoded = try encodeAndDecode(state)
            XCTAssertEqual(encoded, state)
        }
    }

    func testContentTypeEncoding() throws {
        try ContentType.allCases.forEach { type in
            let encoded = try encodeAndDecode(type)
            XCTAssertEqual(encoded, type)
        }
    }

    func testDownloadModelEncoding() throws {
        let model = DownloadModel(id: UUID(), fileUrl: .dummy, destinationUrl: .dummy,
                                  filename: "test", startDate: Date(), endDate: Date(),
                                  state: .completed, contentType: .epub)
        let decodedModel = try encodeAndDecode(model)

        XCTAssertEqual(decodedModel.id, model.id)
        XCTAssertEqual(decodedModel.fileUrl, model.fileUrl)
        XCTAssertEqual(decodedModel.filename, model.filename)
        XCTAssertEqual(decodedModel.startDate, model.startDate)
        XCTAssertEqual(decodedModel.endDate, model.endDate)
        XCTAssertEqual(decodedModel.state, model.state)
        XCTAssertEqual(decodedModel.contentType, model.contentType)
    }
}
