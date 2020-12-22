//
//  Extensions.swift
//  dl-buddy
//
//  Created by ned on 18/12/20.
//

import Foundation

extension String {

    /// Returns `true` if the string is a valid URL
    var isValidURL: Bool {
        guard URL(string: self) != nil else { return false }
        let types: NSTextCheckingResult.CheckingType = [.link]
        guard let detector = try? NSDataDetector(types: types.rawValue), count > 0 else { return false }
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        return detector.numberOfMatches(in: self, options: options, range: NSRange(location: 0, length: count)) > 0
    }

}

extension URL {

    /// Creates an empty URL
    static var empty: URL {
        return URL(string: "https://apple.com/")!
    }

}

extension Int64 {

    var humanReadable: String {
        ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }

}

extension Progress {

    var asString: String {
        let readString: String = completedUnitCount.humanReadable
        let totalString: String = totalUnitCount.humanReadable
        let percentage = String(Int(fractionCompleted * 100)) + "%"
        return "Downloading \(readString) of \(totalString) (\(percentage))"
    }

}

extension Array where Element: Hashable {

    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }

}
