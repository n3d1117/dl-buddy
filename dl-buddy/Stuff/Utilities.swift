//
//  Utilities.swift
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

    /// Creates a dummy URL object
    static var dummy: URL {
        return URL(string: "https://apple.com/")!
    }

    /// Returns the size of the file associated with the url, if any
    var fileSize: Int64? {
        guard exists else { return nil }
        do {
            let values = try resourceValues(forKeys: [.fileSizeKey])
            guard let fileSize = values.fileSize else { return nil }
            return Int64(fileSize)
        } catch {
            return nil
        }
    }

    /// Returns `true` if a file exists at url
    var exists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }

}

extension Int64 {

    /// Returns a human readable representation of a bytes count (e.g: `32783219` -> `32.8MB`)
    var humanReadable: String {
        ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }

}

extension Progress {

    /// Returns a `Codable` compliant version of the progress
    var codableVersion: CodableProgress {
        return CodableProgress(completedUnitCount: completedUnitCount, totalUnitCount: totalUnitCount)
    }

    /// Returns the progress as a string, e.g.: `Downloading 1.2MB of 32.8MB (2.7%)`
    var asString: String {
        let readString: String = completedUnitCount.humanReadable
        let totalString: String = totalUnitCount.humanReadable
        let percentage = String(Int(fractionCompleted * 100)) + "%"
        if totalUnitCount == -1 {
            return "Downloading \(readString)"
        } else {
            return "Downloading \(readString) of \(totalString) (\(percentage))"
        }
    }

}

extension Array where Element: Hashable {

    /// Returns the difference in elements between the specified array and itself
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }

}

extension FileManager {

    /// Returns `true` if a directory exists at the specified url
    func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

}

extension Date {

    /// A custom date formatter for converting a date to a string
    fileprivate var customFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }

    /// A relative date formatter for converting the interval between dates to a string
    fileprivate var relativeDateFormatter: RelativeDateTimeFormatter {
        return RelativeDateTimeFormatter()
    }

    /// Returns a human readable date and time, e.g: `Today at 13:22`
    var humanReadable: String {
        return customFormatter.string(from: self).lowercased()
    }

    /// Returns a human readable time interval between the specified date and itself (e.g. `1 minute ago`)
    func localizedInterval(from: Date) -> String {
        return relativeDateFormatter.localizedString(for: self, relativeTo: from)
    }

}
