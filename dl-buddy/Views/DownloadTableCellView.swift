//
//  DownloadTableCell.swift
//  dl-buddy
//
//  Created by ned on 17/12/20.
//

import Cocoa

class DownloadTableCellView: NSTableCellView {

    // MARK: - IBOutlet properties

    @IBOutlet weak var mainLabel: NSTextField!
    @IBOutlet weak var secondaryLabel: NSTextField!
    @IBOutlet weak var progressView: NSProgressIndicator!

    @IBOutlet weak var showInFinderButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var resumeButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!

    // MARK: - Other properties

    fileprivate var model: DownloadModel!
    fileprivate var isInMouseoverMode: Bool = false

    // MARK: Initializer

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        MenuItem.allCases.forEach({ actionButtonForItem($0).addTrackingArea(trackingArea(for: $0)) })
    }

    override func mouseEntered(with event: NSEvent) {
        if let item = event.trackingArea?.userInfo?["btn"] as? MenuItem {
            isInMouseoverMode = true

            switch item {
            case .remove:
                secondaryLabel.stringValue = "Remove download"
            case .cancel:
                secondaryLabel.stringValue = "Cancel download"
            case .pause:
                secondaryLabel.stringValue = "Pause download"
            case .resume:
                secondaryLabel.stringValue = "Resume download"
            case .showInFinder:
                secondaryLabel.stringValue = "Show in Finder"
            }
        }
    }

    override func mouseExited(with event: NSEvent) {
        isInMouseoverMode = false
        updateUI(with: model)
    }

    // MARK: - Helper functions

    func updateUI(with newModel: DownloadModel) {
        self.model = newModel

        mainLabel.stringValue = model.filename ?? "Loading..."

        switch model.state {
        case .unknown:
            isInMouseoverMode = false
            secondaryLabel.stringValue = "Loading..."
            progressView.doubleValue = 0
            setActionButtonsEnabled([])

        case .completed:
            if !isInMouseoverMode {
                secondaryLabel.stringValue = constructDownloadCompletedString()
            }
            progressView.doubleValue = 1
            setActionButtonsEnabled([.showInFinder, .remove])

        case .failed(let error):
            if !isInMouseoverMode {
                secondaryLabel.stringValue = error
            }
            setActionButtonsEnabled([.remove])

        case .paused:
            if !isInMouseoverMode {
                secondaryLabel.stringValue = "Download paused"
            }
            setActionButtonsEnabled([.resume, .cancel])

        case .downloading(let progress):
            if !isInMouseoverMode {
                secondaryLabel.stringValue = progress.asString
            }
            progressView.doubleValue = progress.fractionCompleted
            setActionButtonsEnabled([.pause, .cancel])
        }
    }

    fileprivate func setActionButtonsEnabled(_ items: [MenuItem]) {
        items.forEach({ actionButtonForItem($0).isHidden = false })
        MenuItem.allCases.difference(from: items).forEach({ actionButtonForItem($0).isHidden = true })
    }

    fileprivate func actionButtonForItem(_ item: MenuItem) -> NSButton {
        switch item {
        case .cancel: return cancelButton
        case .pause: return pauseButton
        case .remove: return removeButton
        case .resume: return resumeButton
        case .showInFinder: return showInFinderButton
        }
    }

    fileprivate func trackingArea(for item: MenuItem) -> NSTrackingArea {
        let rect = actionButtonForItem(item).bounds
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        let userInfo: [String: MenuItem] = ["btn": item]
        return NSTrackingArea(rect: rect, options: options, owner: self, userInfo: userInfo)
    }

    fileprivate func getFileLocalUrl() -> URL? {
        let destinationFolder = model.destinationUrl
        guard let filename = model.filename else { return nil }
        return destinationFolder.appendingPathComponent(filename)
    }

    fileprivate func constructDownloadCompletedString() -> String {
        var finalString = "Download completed"

        if let startDate = model.startDate, let endDate = model.endDate {
            finalString += " \(endDate.humanReadable) \(endDate.localizedInterval(from: startDate))"
        }

        if let size = getFileLocalUrl()?.fileSize?.humanReadable {
            finalString += " — \(size)"
        }
        return finalString
    }

}
