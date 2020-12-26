//
//  CodableProgress.swift
//  dl-buddy
//
//  Created by ned on 25/12/20.
//

import Foundation

struct CodableProgress {

    let completedUnitCount: Int64
    let totalUnitCount: Int64

    init() {
        self.init(completedUnitCount: 0, totalUnitCount: 0)
    }

    init(completedUnitCount: Int64, totalUnitCount: Int64) {
        self.completedUnitCount = completedUnitCount
        self.totalUnitCount = totalUnitCount
    }

    fileprivate var progress: Progress {
        let progress = Progress(totalUnitCount: totalUnitCount)
        progress.completedUnitCount = completedUnitCount
        return progress
    }

    var asString: String {
        return progress.asString
    }

    var fractionCompleted: Double {
        return progress.fractionCompleted
    }
}

// MARK: - Equatable conformance

extension CodableProgress: Equatable { }

// MARK: - Codable conformance

extension CodableProgress: Codable { }
