//
//  ViewController.swift
//  dl-buddy
//
//  Created by ned on 15/12/20.
//

import Cocoa

class MainViewController: NSViewController {

    // MARK: - IBOutlet Properties

    @IBOutlet internal weak var tableView: NSTableView!

    // MARK: - Other properties

    internal var contextualMenu: NSMenu?

    // MARK: - Setup Download Manager

    lazy internal var downloadManager: DownloadManager = { [unowned self] in
        let manager = DownloadManager()
        manager.delegate = self
        return manager
    }()

    // MARK: - VC Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialContextualMenu()
    }

    // MARK: - Helpers

    fileprivate func newDownloadRequested(with model: URLAndDestModel) {
        downloadManager.startDownload(url: model.url, destinationFolder: model.destinationFolder)
    }

    fileprivate func updateCell(at row: Int, with model: DownloadModel) {
        guard tableView.numberOfRows >= row + 1 else { return }
        if let cell = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? DownloadTableCellView {
            cell.updateUI(with: model)
        }
    }

    // MARK: - IBAction Methods

    @IBAction fileprivate func addButtonTapped(sender: NSToolbarItem) {

        /// Prepare a `URLAndDestinationViewController` modal sheet
        let sceneId = NSStoryboard.SceneIdentifier(stringLiteral: "URLAndDestinationViewController")
        guard let windowController = storyboard?.instantiateController(withIdentifier: sceneId) as? NSWindowController,
              let sheetWindow = windowController.window,
              let destinationVC = windowController.contentViewController as? DestinationPickerViewController
        else { return }

        /// Present sheet and handle completion
        view.window?.beginSheet(sheetWindow, completionHandler: { [weak self] response in
            if response == .OK {
                guard let model = destinationVC.urlAndDestinationModel else { return }
                self?.newDownloadRequested(with: model)
            }
        })

    }

    @IBAction internal func pauseDownloadClicked(_ sender: AnyObject) {
        guard let row = clickedRow(sender) else { return }
        downloadManager.pauseDownload(at: row)
    }

    @IBAction internal func resumeDownloadClicked(_ sender: AnyObject) {
        guard let row = clickedRow(sender) else { return }
        downloadManager.resumeDownload(at: row)
    }

    @IBAction internal func cancelDownloadClicked(_ sender: AnyObject) {
        guard let row = clickedRow(sender) else { return }
        downloadManager.cancelDownload(index: row)
    }

    @IBAction internal func removeDownloadClicked(_ sender: AnyObject) {
        guard let row = clickedRow(sender) else { return }
        downloadManager.removeDownload(index: row)
    }

    @IBAction internal func showInFinderClicked(_ sender: AnyObject) {
        guard let row = clickedRow(sender) else { return }
        let model = downloadManager.downloads[row]
        let destinationFolder = model.destinationUrl
        guard FileManager.default.directoryExists(at: destinationFolder) else { return }
        guard let filename = model.filename else { return }
        let finalUrl = destinationFolder.appendingPathComponent(filename)
        guard FileManager.default.fileExists(at: finalUrl) else {
            NSWorkspace.shared.activateFileViewerSelecting([destinationFolder])
            return
        }
        NSWorkspace.shared.activateFileViewerSelecting([finalUrl])
    }

    internal func clickedRow(_ sender: AnyObject? = nil) -> Int? {
        if tableView.clickedRow >= 0 {
            return tableView.clickedRow
        } else if let selectedRow = tableView.selectedRowIndexes.map({ Int($0) }).first {
            return selectedRow
        } else if let button = sender as? NSButton {
            return tableView.row(for: button)
        } else {
            return nil
        }
    }
}

// MARK: - NSTableViewDataSource and NSTableViewDelegate conformance

extension MainViewController: NSTableViewDataSource, NSTableViewDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return downloadManager.downloads.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellId = NSUserInterfaceItemIdentifier(rawValue: "DownloadTableCell")
        let model = downloadManager.downloads[row]
        if let cell = tableView.makeView(withIdentifier: cellId, owner: nil) as? DownloadTableCellView {
            cell.updateUI(with: model)
            return cell
        }
        return nil
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        updateContextMenus()
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return DownloadTableCellRowView()
    }

}

// MARK: - DownloadManagerDelegate conformance

extension MainViewController: DownloadManagerDelegate {

    func downloadStarted(for model: DownloadModel, at index: Int) {
        tableView.insertRows(at: IndexSet(integer: index), withAnimation: .effectGap)
    }

    func downloadProgress(for model: DownloadModel, at index: Int) {
        updateCell(at: index, with: model)
    }

    func downloadPaused(for model: DownloadModel, at index: Int) {
        updateCell(at: index, with: model)
        updateContextMenus()
    }

    func downloadResumed(for model: DownloadModel, at index: Int) {
        updateCell(at: index, with: model)
        updateContextMenus()
    }

    func downloadFinishedSuccess(for model: DownloadModel, at index: Int) {
        updateCell(at: index, with: model)
        updateContextMenus()
    }

    func downloadFinishedError(for model: DownloadModel, at index: Int) {
        updateCell(at: index, with: model)
        updateContextMenus()
    }

    func downloadCancelled(for model: DownloadModel, at index: Int) {
        updateCell(at: index, with: model)
        updateContextMenus()
    }

    func downloadRemoved(at index: Int) {
        tableView.removeRows(at: IndexSet(integer: index), withAnimation: .effectFade)
    }

}
