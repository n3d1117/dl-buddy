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
        case downloading(progress: Progress)
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
}

// MARK: - Equatable conformance

extension DownloadModel.State: Equatable { }
