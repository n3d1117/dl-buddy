//
//  MenuItem.swift
//  dl-buddy
//
//  Created by ned on 23/12/20.
//

import Foundation
import Cocoa

enum MenuItem {

    case pause
    case resume
    case cancel
    case remove
    case showInFinder

    /// The associated `NSMenuItem`
    var item: NSMenuItem {
        switch self {
        case .pause:
            return NSMenuItem(title: "Pause",
                              action: #selector(MainViewController.pauseDownloadClicked(_:)),
                              keyEquivalent: "p")
        case .resume:
            return NSMenuItem(title: "Resume",
                              action: #selector(MainViewController.resumeDownloadClicked(_:)),
                              keyEquivalent: "r")
        case .cancel:
            return NSMenuItem(title: "Cancel",
                              action: #selector(MainViewController.cancelDownloadClicked(_:)),
                              keyEquivalent: "u")
        case .remove:
            // Note: `\u{08}` = ⌘⌫
            return NSMenuItem(title: "Remove",
                              action: #selector(MainViewController.removeDownloadClicked(_:)),
                              keyEquivalent: "\u{08}")
        case .showInFinder:
            return NSMenuItem(title: "Show in Finder",
                              action: #selector(MainViewController.showInFinderClicked(_:)),
                              keyEquivalent: "g")
        }
    }

    /// The associated menu bar item, set in Storyboard
    var menuBarItem: NSMenuItem? {

        guard let mainMenu = NSApplication.shared.mainMenu else { return nil }
        guard let downloadsSubMenu = mainMenu.item(withTitle: "Downloads")?.submenu else { return nil }

        switch self {
        case .pause: return downloadsSubMenu.item(withTitle: "Pause")
        case .resume: return downloadsSubMenu.item(withTitle: "Resume")
        case .cancel: return downloadsSubMenu.item(withTitle: "Cancel")
        case .remove: return downloadsSubMenu.item(withTitle: "Remove")
        case .showInFinder: return downloadsSubMenu.item(withTitle: "Show in Finder")
        }
    }
}

// MARK: - CaseIterable conformance

extension MenuItem: CaseIterable { }
