//
//  DownloadManager+Persistence.swift
//  dl-buddy
//
//  Created by ned on 25/12/20.
//

import Foundation

extension DownloadManager {

    static let storageKey: String = "dl-buddy-downloads"

    /// Cache all current downloads and progress to disk
    func cacheDownloadsList() {

        /// In order to cache all resume data synchronously for every active download, we need a dispatch group
        /// otherwise the saved data could be incomplete (since network requests are async by default)
        let group = DispatchGroup()

        for download in downloads {

            guard let index = index(for: download.id), downloads[index].request != nil else { continue }

            /// Update temporary progress, to be able to restore it correctly at next launch
            if download.state != .unknown {
                downloads[index].temporaryProgress = self.downloads[index].request?.downloadProgress.fractionCompleted
            }

            /// If the task is either downloading or pausing, then also cache the resume data object
            switch download.state {
            case .downloading, .paused:
                group.enter()
                downloads[index].request?.cancel { data in
                    self.downloads[index].resumeData = data
                    group.leave()
                }
            default: continue
            }
        }

        /// Wait for group completion
        group.wait()

        /// Only consider downloads that are not in an unknown state
        let cacheableDownloads = downloads.filter({ $0.state != .unknown })

        /// Finally, encode the array to JSON and add it to UserDefaults storage
        if let data = try? JSONEncoder().encode(cacheableDownloads) {
            UserDefaults.standard.set(data, forKey: DownloadManager.storageKey)
        }
    }

    /// Load cached downloads from disk
    func loadCachedDownloads() {
        /// Get cached data
        guard let data = UserDefaults.standard.value(forKey: DownloadManager.storageKey) as? Data else { return }

        /// Decode it into an array of `DownloadModel`
        guard let cachedDownloads = try? JSONDecoder().decode([DownloadModel].self, from: data) else { return }

        /// Assign it to the main array
        downloads = cachedDownloads

        for download in downloads {
            guard let index = index(for: download.id) else { return }

            /// If a download was in progress before the app was closed, then restart it right away
            if case .downloading = download.state {
                tryResumeDownloadFromPreviousData(index: index)
            }
        }
    }

}
