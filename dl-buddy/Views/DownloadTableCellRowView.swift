//
//  DownloadTableCellRowView.swift
//  dl-buddy
//
//  Created by ned on 22/12/20.
//

import Cocoa

/// A `NSTableRowView` subclass used to set a different selection color than the standard blue
class DownloadTableCellRowView: NSTableRowView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        wantsLayer = true
        isEmphasized = false
        selectionHighlightStyle = .regular
    }

    override func drawSelection(in dirtyRect: NSRect) {
        if selectionHighlightStyle != .none {
            NSColor.controlAccentColor.withAlphaComponent(0.2).setFill()
            NSBezierPath(rect: bounds).fill()
        }
    }
}
