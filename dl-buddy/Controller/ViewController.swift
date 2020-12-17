//
//  ViewController.swift
//  dl-buddy
//
//  Created by ned on 15/12/20.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBAction func addDownloadButtonTapped(sender: NSToolbarItem) {
        print("add button tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ViewController: NSTableViewDelegate {

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DownloadTableCell"), owner: nil) as? DownloadTableCell {
        cell.sampleLabel.stringValue = "sample cell"
      return cell
    }
    return nil
  }

}

extension ViewController: NSTableViewDataSource {
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return 3
  }

}


