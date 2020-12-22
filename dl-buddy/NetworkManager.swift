//
//  NetworkManager.swift
//  dl-buddy
//
//  Created by ned on 21/12/20.
//

import Foundation
import Alamofire

enum NetworkManager {

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

    static func downloadFile(from url: URL, destinationFolder: URL, completion: @escaping((DownloadRequest) -> Void)) {
        let destination: DownloadRequest.Destination = { _, response in
            let filename = response.suggestedFilename ?? "unknown"
            let fileUrl = destinationFolder.appendingPathComponent(filename)
            return (fileUrl, options: [.removePreviousFile])
        }
        completion(AF.download(url, to: destination))
    }

}
