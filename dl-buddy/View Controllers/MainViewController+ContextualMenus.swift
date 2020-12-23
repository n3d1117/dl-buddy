//
//  MainViewController+ContextualMenus.swift
//  dl-buddy
//
//  Created by ned on 21/12/20.
//

import Cocoa

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

    /// Logic behind model state and menu item mapping
    fileprivate func menuItems(for state: DownloadModel.State) -> [MenuItem] {
        switch state {
        case .completed: return [.showInFinder, .remove]
        case .failed, .unknown: return [.remove]
        case .paused: return [.resume, .cancel]
        case .downloading: return [.pause, .cancel]
        }
    }

    /// Enable specified items, disable all others
    fileprivate func setMenuBarItemsEnabled(_ items: [MenuItem]) {
        items.forEach({ $0.menuBarItem?.isEnabled = true })
        MenuItem.allCases.difference(from: items).forEach({ $0.menuBarItem?.isEnabled = false })
    }
}
