//
//  DownloadManagerDelegate.swift
//  dl-buddy
//
//  Created by ned on 22/12/20.
//

protocol DownloadManagerDelegate: class {

    /// Delegate method called every time a new download has started
    /// - Parameters:
    ///   - model: the `DownloadModel` relative to the download task that started
    ///   - index: index of the model
    func downloadStarted(for model: DownloadModel, at index: Int)

    /// Delegate method called every time a download progress is updated
    /// - Parameters:
    ///   - model: the `DownloadModel` whose progress was updated
    ///   - index: index of the model
    func downloadProgress(for model: DownloadModel, at index: Int)

    /// Delegate method called every time a download task is paused
    /// - Parameters:
    ///   - model: the `DownloadModel` whose task was paused
    ///   - index: index of the model
    func downloadPaused(for model: DownloadModel, at index: Int)

    /// Delegate method called every time a download task is resumed
    /// - Parameters:
    ///   - model: the `DownloadModel` whose task was resumed
    ///   - index: index of the model
    func downloadResumed(for model: DownloadModel, at index: Int)

    /// Delegate method called every time a download task has finished successfully
    /// - Parameters:
    ///   - model: the `DownloadModel` whose task has finished
    ///   - index: index of the model
    func downloadFinishedSuccess(for model: DownloadModel, at index: Int)

    /// Delegate method called every time a download task has finished with error
    /// - Parameters:
    ///   - model: the `DownloadModel` whose task has finished with error
    ///   - index: index of the model
    func downloadFinishedError(for model: DownloadModel, at index: Int)

    /// Delegate method called every time a download task is cancelled
    /// - Parameters:
    ///   - model: the `DownloadModel` whose task is cancelled
    ///   - index: index of the model
    func downloadCancelled(for model: DownloadModel, at index: Int)

    /// Delegate method called every time a download is removed from the list
    /// - Parameter index: index of the model
    func downloadRemoved(at index: Int)
}
