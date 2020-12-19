//
//  ViewController.swift
//  dl-buddy
//
//  Created by ned on 15/12/20.
//

import Cocoa

class MainViewController: NSViewController {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet fileprivate weak var tableView: NSTableView!
    
    // MARK: - VC Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Helpers
    
    fileprivate func newDownloadRequested(with model: URLAndDestModel) {
        print(model.destinationFolder)
        print(model.url)
    }
    
    // MARK: - IBAction Methods
    
    @IBAction fileprivate func addButtonTapped(sender: NSToolbarItem) {
        
        /// Prepare a `URLAndDestinationViewController` modal sheet
        let sceneIdentifier = NSStoryboard.SceneIdentifier(stringLiteral: "URLAndDestinationViewController")
        guard let windowController = storyboard?.instantiateController(withIdentifier: sceneIdentifier) as? NSWindowController,
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
}

// MARK: - NSTableViewDelegate conformance

extension MainViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DownloadTableCell"), owner: nil) as? DownloadTableCellView {
            cell.sampleLabel.stringValue = "sample cell"
            return cell
        }
        return nil
    }
    
}

// MARK: - NSTableViewDataSource conformance

extension MainViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 3
    }
    
}


