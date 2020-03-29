//
//  DownloaderService.swift
//  UpdateService
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class DownloaderService: NSObject, URLSessionDownloadDelegate{
    public static let kTotalBytesWritten = "totalBytesWritten"
    public static let kTotalBytesExpectedToWrite = "totalBytesExpectedToWrite"
    public static let kFileLocation = "fileLocation"
    public static let kErrorDescription = "errorDescription"
    
    public func downloadFile(fileURL: URL){
        let config = URLSessionConfiguration.background(withIdentifier: "AppDownload")
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let backgroundTask = session.downloadTask(with: fileURL)
        backgroundTask.resume()
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let info = [DownloaderService.kTotalBytesWritten: totalBytesWritten, DownloaderService.kTotalBytesExpectedToWrite: totalBytesExpectedToWrite]
        DistributedNotificationCenter.default().postNotificationName(.downloadTaskProgess, object: nil, userInfo: info, deliverImmediately: true)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let savedURL = documentsURL.appendingPathComponent(location.lastPathComponent)
            try FileManager.default.moveItem(at: location, to: savedURL)
            
            let info = [DownloaderService.kFileLocation: savedURL]
            DistributedNotificationCenter.default().postNotificationName(.downloadTaskFinished, object: nil, userInfo: info, deliverImmediately: true)
        }catch{
            let info = [DownloaderService.kErrorDescription: error.localizedDescription]
            DistributedNotificationCenter.default().postNotificationName(.downloadTaskError, object: nil, userInfo: info, deliverImmediately: true)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let info = [DownloaderService.kErrorDescription: error?.localizedDescription]
        DistributedNotificationCenter.default().postNotificationName(.downloadTaskError, object: nil, userInfo: info, deliverImmediately: true)
    }
}

extension Notification.Name{
    static let downloadTaskProgess = Notification.Name("DownloaderService.downloadTaskProgess")
    static let downloadTaskFinished = Notification.Name("DownloaderService.downloadTaskFinished")
    static let downloadTaskError = Notification.Name("DownloaderService.downloadTaskError")
}
