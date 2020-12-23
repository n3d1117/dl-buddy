//
//  DownloadManager.swift
//  dl-buddy
//
//  Created by ned on 20/12/20.
//

import Foundation

class DownloadManager {

    // MARK: - Properties

    /// The download manager delegate
    weak var delegate: DownloadManagerDelegate?

    /// The list of all downloads
    var downloads: [DownloadModel] = []

    // MARK: - Handle download

    func startDownload(url: URL, destinationFolder: URL) {

        /// Instantiate model and add it to the downloads list
        let model = DownloadModel(fileUrl: url, destinationUrl: destinationFolder)
        downloads.append(model)

        /// Get filename from url
        NetworkManager.getFilename(from: url) { [weak self] filename in
            guard let self = self else { return }

            /// Update model with correct filename
            if let index = self.index(for: model.id) {
                self.downloads[index].filename = filename
            }

            /// Start file download
            NetworkManager.downloadFile(from: url, destinationFolder: destinationFolder) { request in

                if let index = self.index(for: model.id) {

                    /// Update model with request and start date
                    self.downloads[index].request = request
                    self.downloads[index].startDate = Date()

                    /// Notify delegate that download started
                    self.delegate?.downloadStarted(for: self.downloads[index], at: index)

                    /// Handle progress
                    self.handleProgress(for: self.downloads[index].id)

                    /// Handle completion
                    self.handleCompletion(for: self.downloads[index].id)
                }

            }
        }
    }

    fileprivate func handleProgress(for modelId: UUID) {
        guard let index = index(for: modelId) else { return }

        downloads[index].request?.downloadProgress { [weak self] progress in
            guard let self = self else { return }

            /// Recalculate index, it may have changed if a download was removed in the meantime
            guard let index = self.index(for: modelId), let request = self.downloads[index].request else { return }

            /// Sometimes the `downloadProgress` closure gets called even after pausing the download,
            /// so, to avoid it, we check if the request was suspended
            if !request.isSuspended {

                /// Update model state and notify delegate of the progress
                self.downloads[index].state = .downloading(progress: progress)
                self.delegate?.downloadProgress(for: self.downloads[index], at: index)
            }

        }
    }

    fileprivate func handleCompletion(for modelId: UUID) {
        guard let index = index(for: modelId) else { return }

        downloads[index].request?.response { [weak self] response in
            guard let self = self else { return }

            /// Recalculate index, it may have changed if a download was removed in the meantime
            guard let index = self.index(for: modelId) else { return }

            /// Update model's end date
            self.downloads[index].endDate = Date()

            switch response.result {
            case .success:

                /// Update model state and notify delegate that the download finished successfully
                self.downloads[index].state = .completed
                self.delegate?.downloadFinishedSuccess(for: self.downloads[index], at: index)

            case .failure(let error):

                /// Update model state and notify delegate that the download finished with error
                self.downloads[index].state = .failed(error: error.localizedDescription)
                self.delegate?.downloadFinishedError(for: self.downloads[index], at: index)
            }
        }
    }

    // MARK: - Helper functions

    func pauseDownload(at index: Int) {
        guard downloads.indices.contains(index), downloads[index].state != .paused else { return }
        downloads[index].request?.suspend()
        downloads[index].state = .paused
        delegate?.downloadPaused(for: downloads[index], at: index)
    }

    func resumeDownload(at index: Int) {
        guard downloads.indices.contains(index), downloads[index].state == .paused else { return }
        downloads[index].request?.resume()
        delegate?.downloadResumed(for: downloads[index], at: index)
    }

    func cancelDownload(index: Int) {
        guard downloads.indices.contains(index) else { return }
        downloads[index].request?.cancel()
        delegate?.downloadCancelled(for: downloads[index], at: index)
    }

    func removeDownload(index: Int) {
        guard downloads.indices.contains(index) else { return }
        downloads[index].request?.cancel()
        downloads[index].request = nil
        downloads.remove(at: index)
        delegate?.downloadRemoved(at: index)
    }

    // MARK: - Utilities

    /// Returns the correct index of the model with the specified uuid
    fileprivate func index(for modelId: UUID) -> Int? {
        downloads.firstIndex(where: {$0.id == modelId})
    }

}
