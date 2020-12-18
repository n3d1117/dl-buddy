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
    
    fileprivate func newDownloadRequested(with model: DownloadURLAndDestination) {
        print(model.destination)
        print(model.fileUrl)
    }
    
    // MARK: - IBAction Methods
    
    @IBAction fileprivate func addDownloadButtonTapped(sender: NSToolbarItem) {
        
        /// Prepare a `URLAndDestinationViewController` modal sheet
        let sceneIdentifier = NSStoryboard.SceneIdentifier(stringLiteral: "URLAndDestinationViewController")
        guard let windowController = storyboard?.instantiateController(withIdentifier: sceneIdentifier) as? NSWindowController,
              let resizeWindow = windowController.window,
              let destinationViewController = windowController.contentViewController as? URLAndDestinationViewController else { return }
        
        /// Present sheet and handle completion
        view.window?.beginSheet(resizeWindow, completionHandler: { [weak self] response in
            if response == NSApplication.ModalResponse.OK {
                guard let model = destinationViewController.urlAndDestinationModel else { return }
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


