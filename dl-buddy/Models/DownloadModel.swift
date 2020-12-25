//
//  DownloadModel.swift
//  dl-buddy
//
//  Created by ned on 20/12/20.
//

import Foundation

struct DownloadModel {

    /// An enum representing every state the model could be in
    enum State {
        case unknown
        case downloading(progress: CodableProgress)
        case paused
        case completed
        case failed(error: String)
    }

    /// The model's unique identifier
    var id = UUID() // swiftlint:disable:this identifier_name

    /// URL of the file to download
    var fileUrl: URL

    /// URL of the destination folder where to save the file
    var destinationUrl: URL

    /// The filename (e.g. `file.jpg`)
    var filename: String?

    /// The date when in which download started
    var startDate: Date?

    /// The date in which the download ended
    var endDate: Date?

    /// The state associated with the model, initially unknown
    var state: State = .unknown

    /// The content type associated with the model, initially unknown
    var contentType: ContentType = .unknown

    /// The associated network request
    var request: NetworkManager.Request?

    /// The resume data, used to restart download after app is closed
    var resumeData: Data?

    /// The download progress fraction, used to restore the progress bar after app is closed
    var temporaryProgress: Double?
}

// MARK: - Equatable conformance

extension DownloadModel.State: Equatable { }

// MARK: - Codable conformance

extension DownloadModel: Codable {

    /// In order to conform to `Codable`, the only non-Codable compliant object (`request`) must be
    /// excluded from coding keys and will always be treated as `nil` when decoding
    private enum CodingKeys: String, CodingKey {
        case id // swiftlint:disable:this identifier_name
        case fileUrl
        case destinationUrl
        case filename
        case startDate
        case endDate
        case state
        case contentType
        case resumeData
        case temporaryProgress
    }
}
