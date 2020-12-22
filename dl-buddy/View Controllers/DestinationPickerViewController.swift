//
//  URLAndDestinationPickerViewController.swift
//  dl-buddy
//
//  Created by ned on 18/12/20.
//

import Cocoa

class DestinationPickerViewController: NSViewController {

    // MARK: - IBOutlet Properties

    @IBOutlet fileprivate weak var urlTextField: NSTextField!
    @IBOutlet fileprivate weak var destinationPathControl: NSPathControl!
    @IBOutlet fileprivate weak var downloadButton: NSButton!

    // MARK: - Properties

    var urlAndDestinationModel: URLAndDestModel?

    // MARK: - VC Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Set `NSTextField` and `NSPathControl` delegates
        urlTextField.delegate = self
        destinationPathControl.delegate = self

        /// Make `downloadButton` the primary button
        downloadButton.keyEquivalent = "\r"

        /// Initially disable `downloadButton` (it's enabled later after input validation)
        downloadButton.isEnabled = false

        /// Set path control initial URL to `~/Downloads` folder
        let userFolderName: String = NSUserName()
        let initialFolder: String = "/Users/\(userFolderName)/Downloads"
        let initialDestinationUrl = URL(fileURLWithPath: initialFolder)
        destinationPathControl.url = initialDestinationUrl

        /// Instantiate an empty model
        urlAndDestinationModel = URLAndDestModel(url: .empty, destinationFolder: initialDestinationUrl)
    }

    // MARK: - IBAction Methods

    @IBAction fileprivate func downloadButtonPressed(sender: NSButton) {
        endSheet(.OK)
    }

    @IBAction fileprivate func cancelButtonPressed(sender: NSButton) {
        endSheet(.cancel)
    }

    // MARK: - Helpers

    fileprivate func endSheet(_ returnCode: NSApplication.ModalResponse) {
        guard let window = view.window, let parent = window.sheetParent else { return }
        parent.endSheet(window, returnCode: returnCode)
    }

    fileprivate func resetUrlTextFieldBackgroundColor() {
        urlTextField.backgroundColor = NSColor.textBackgroundColor
    }

    fileprivate func highlightErrorInUrlTextField() {
        urlTextField.backgroundColor = NSColor.systemRed.withAlphaComponent(0.05)
    }

    fileprivate func setDownloadButtonEnabled(_ value: Bool) {
        downloadButton.isEnabled = value
    }

    fileprivate func updateModelFileUrl(_ fileUrl: URL) {
        urlAndDestinationModel?.url = fileUrl
    }

    fileprivate func updateModelDestination(_ destination: URL) {
        urlAndDestinationModel?.destinationFolder = destination
    }

    fileprivate func handleUrlInputTextChanged(value: String) {
        if value.isEmpty {
            resetUrlTextFieldBackgroundColor()
            setDownloadButtonEnabled(false)

        } else if !value.isValidURL {
            highlightErrorInUrlTextField()
            setDownloadButtonEnabled(false)

        } else {
            guard let fileUrl = URL(string: value) else { return }
            resetUrlTextFieldBackgroundColor()
            setDownloadButtonEnabled(true)
            updateModelFileUrl(fileUrl)
        }
    }

    fileprivate func handleDestinationChanged() {
        guard let newDestination = destinationPathControl.url else { return }
        updateModelDestination(newDestination)
    }

}

// MARK: - NSTextFieldDelegate conformance

extension DestinationPickerViewController: NSTextFieldDelegate {

    /// Called whenever text changes inside the textField
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        handleUrlInputTextChanged(value: textField.stringValue)
    }

}

// MARK: - NSPathControlDelegate conformance

extension DestinationPickerViewController: NSPathControlDelegate {

    /// Called whenever a new folder is selected, either from the dropdown or the `Choose...` panel
    @IBAction func pathItemSelected(sender: NSPathControl) {
        guard let newItem = sender.clickedPathItem else { return }

        /// For some reason, the path gets updated correctly when using the `Choose...` panel, but not
        /// when selecting a folder from the dropdown; so, in case a folder was selected from the dropdown, we need
        /// to update the item manually. Note that `sender.url` and `newItem.url` may differ due to a trailing slash,
        /// so we standardize them before checking their equality
        if newItem.url?.standardizedFileURL != sender.url?.standardizedFileURL {
            destinationPathControl.url = newItem.url
        }

        handleDestinationChanged()
    }

}
