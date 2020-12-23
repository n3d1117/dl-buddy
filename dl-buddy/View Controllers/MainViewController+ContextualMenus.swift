//
//  MainViewController+ContextualMenus.swift
//  dl-buddy
//
//  Created by ned on 21/12/20.
//

import Cocoa

// MARK: - Contextual menus logic

enum MenuItem: CaseIterable {

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

// MARK: - NSMenuDelegate conformance

extension MainViewController: NSMenuDelegate {

    func menuWillOpen(_ menu: NSMenu) {

        /// In case a menu is opened from a right click on a row, we need to
        /// deselect all the other rows to avoid UI inconsistencies
        for row in 0..<tableView.numberOfRows where row != tableView.clickedRow {
            tableView.deselectRow(row)
        }

        updateContextMenus()
    }

    /// Sets up an initial contextual menu with a single remove item, setting delegate to self
    internal func setupInitialContextualMenu() {
        contextualMenu = NSMenu()
        contextualMenu?.delegate = self
        contextualMenu?.addItem(MenuItem.remove.item)
        tableView.menu = contextualMenu
    }

    /// Update menu items both in right click menus and in the menu bar
    internal func updateContextMenus() {
        guard let row = clickedRow() else { return }

        /// Clear current items
        contextualMenu?.removeAllItems()

        /// Add new items
        let menuItems = appropriateContextualMenuItems(for: row)
        menuItems.forEach({ contextualMenu?.addItem($0.item) })

        /// Update menu
        tableView.menu = contextualMenu

        /// Update main menu bar items
        setMenuBarItemsEnabled(menuItems)
    }

    /// Return appropriate menu items for given row
    fileprivate func appropriateContextualMenuItems(for row: Int) -> [MenuItem] {
        guard downloadManager.downloads.indices.contains(row) else { return [] }
        let model = downloadManager.downloads[row]
        return menuItems(for: model.state)
    }

    /// Logic begind model state and menu item mapping
    fileprivate func menuItems(for state: DownloadModel.State) -> [MenuItem] {
        switch state {
        case .completed: return [.showInFinder, .remove]
        case .failed, .unknown: return [.remove]
        case .paused: return [.resume, .cancel]
        case .downloading: return [.pause, .cancel]
        }
    }

    /// Enable given items, disable all others
    fileprivate func setMenuBarItemsEnabled(_ items: [MenuItem]) {
        items.forEach({ $0.menuBarItem?.isEnabled = true })
        MenuItem.allCases.difference(from: items).forEach({ $0.menuBarItem?.isEnabled = false })
    }
}
