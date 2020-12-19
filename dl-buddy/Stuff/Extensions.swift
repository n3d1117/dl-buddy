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
        return detector.numberOfMatches(in: self, options: options, range: NSMakeRange(0, count)) > 0
    }
    
}

extension URL {
    
    /// Creates an empty URL
    static var empty: URL {
        return URL(string: "https://apple.com/")!
    }
    
}
