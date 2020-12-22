//
//  DownloadModel.swift
//  dl-buddy
//
//  Created by ned on 20/12/20.
//

import Foundation
import Alamofire

struct DownloadModel {

    enum State {
        case unknown
        case downloading(progress: Progress)
        case paused
        case completed
        case failed(error: String)
    }

    var id = UUID() // swiftlint:disable:this identifier_name
    var fileUrl: URL
    var destinationUrl: URL
    var filename: String?
    var startDate: Date?
    var endDate: Date?
    var state: State = .unknown
    var request: DownloadRequest?
}

extension DownloadModel.State: Equatable { }
