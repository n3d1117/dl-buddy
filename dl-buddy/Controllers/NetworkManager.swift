//
//  NetworkManager.swift
//  dl-buddy
//
//  Created by ned on 21/12/20.
//

import Foundation
import Alamofire

enum NetworkManager {

    typealias Request = Alamofire.DownloadRequest

    /// Request a suggested file name from the server, using a HTTP HEAD request
    /// - Parameters:
    ///   - url: url of the file to download
    ///   - completion: callback containing the suggested filename, if found, or the url string itself
    static func getFilename(from url: URL, completion: @escaping((String) -> Void)) {
        AF.request(url, method: .head).responseString { response in
            //print("content type: \(response.response!.allHeaderFields["Content-Type"])")

            if let filename = response.response?.suggestedFilename {
                completion(filename)
            } else {
                completion(url.absoluteString)
            }
        }
    }

    /// Starts file download using Alamofire to the specified destination
    /// - Parameters:
    ///   - url: url of the file to download
    ///   - destinationFolder: local folder where to save the downloaded file
    ///   - completion: callback containing the request
    static func downloadFile(from url: URL, destinationFolder: URL, completion: @escaping((Request) -> Void)) {
        let destination: Request.Destination = { _, response in
            let filename = response.suggestedFilename ?? "unknown"
            let fileUrl = destinationFolder.appendingPathComponent(filename)
            return (fileUrl, options: [.removePreviousFile])
        }
        completion(AF.download(url, to: destination))
    }

}
