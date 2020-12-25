//
//  DownloadModel+Persistence.swift
//  dl-buddy
//
//  Created by ned on 24/12/20.
//

import Foundation

extension DownloadModel.State {

    // MARK: - Define coding keys

    fileprivate enum CodingKeys: String, CodingKey {
        case unknown
        case downloading
        case paused
        case completed
        case failed
    }

    // MARK: - Decode

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        func decodeString(_ key: CodingKeys) throws -> String {
            return try container.decode(String.self, forKey: key)
        }

        if let value = try? container.decode(CodableProgress.self, forKey: .downloading) {
            self = .downloading(progress: value)

        } else if let value = try? decodeString(.unknown), value == CodingKeys.unknown.rawValue {
            self = .unknown

        } else if let value = try? decodeString(.paused), value == CodingKeys.paused.rawValue {
            self = .paused

        } else if let value = try? decodeString(.completed), value == CodingKeys.completed.rawValue {
            self = .completed

        } else if let value = try? decodeString(.failed) {
            self = .failed(error: value)

        } else {
            print("FUCJ")
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match")
            )
        }
    }

    // MARK: - Encode

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .downloading(let progress): try container.encode(progress, forKey: .downloading)
        case .unknown: try container.encode(CodingKeys.unknown.rawValue, forKey: .unknown)
        case .paused: try container.encode(CodingKeys.paused.rawValue, forKey: .paused)
        case .completed: try container.encode(CodingKeys.completed.rawValue, forKey: .completed)
        case .failed(let error): try container.encode(error, forKey: .failed)
        }
    }
}

// MARK: - Codable conformance

extension DownloadModel.State: Codable { }
