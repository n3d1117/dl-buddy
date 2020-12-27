//
//  ContentType.swift
//  dl-buddy
//
//  Created by ned on 23/12/20.
//

import Foundation

enum ContentType: String {

    case pdf = "application/pdf"
    case zip = "application/zip"
    case mkv = "video/x-matroska"
    case dmg = "application/octet-stream"
    case mp3 = "audio/mp3"
    case mp4 = "video/mp4"
    case epub = "application/epub+zip"
    case gif = "image/gif"
    case png = "image/png"
    case jpeg = "image/jpeg"
    case unknown = ""

    var associatedImageGlyph: String {
        switch self {
        case .pdf: return "doc.fill"
        case .zip: return "archivebox.fill"
        case .mkv, .mp4: return "play.tv.fill"
        case .dmg: return "opticaldiscdrive.fill"
        case .mp3: return "music.quarternote.3"
        case .gif, .jpeg, .png: return "photo.fill"
        case .epub: return "book.fill"
        default: return "square.and.arrow.down.fill"
        }
    }

}

// MARK: - Equatable conformance

extension ContentType: Equatable { }

// MARK: - CaseIterable conformance

extension ContentType: CaseIterable { }

// MARK: - Codable conformance

extension ContentType: Codable { }
