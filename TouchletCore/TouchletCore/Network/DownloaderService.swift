//
//  DownloaderService.swift
//  UpdateService
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class DownloaderService: NSObject{
    public static let instance = DownloaderService()
    public weak var delegate: DownloaderServiceDelegate?
    
    public var downloadTask: URLSessionDownloadTask?
    public var downloadedFilePath: URL?
    
    var session: URLSession?
    
    public func downloadFile(fileURL: URL){
        downloadTask = session?.downloadTask(with: fileURL)
        downloadTask?.resume()
    }
    
    public func findTask(with url: URL, completionHandler: @escaping (URLSessionTask?)->()){
        session?.getAllTasks(completionHandler: { (tasks) in
            completionHandler(tasks.first{$0.originalRequest?.url == url})
        })
    }
    
    private override init() {
        super.init()

        let config = URLSessionConfiguration.background(withIdentifier: "AppDownload")
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }
    
    public func cancelDownload(){downloadTask?.cancel()}
}

extension DownloaderService: URLSessionDownloadDelegate{
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        delegate?.downloadService(downloadService: self, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            downloadedFilePath = documentsURL.appendingPathComponent(downloadTask.currentRequest!.url!.lastPathComponent)
            
            try FileManager.default.removeItem(at: downloadedFilePath!)
            try FileManager.default.moveItem(at: location, to: downloadedFilePath!)
                        
            delegate?.downloadService(downloadService: self, didFinishDownloadingTo: downloadedFilePath!)
        }catch{
            delegate?.downloadService(downloadService: self, didCompleteWithError: error)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        delegate?.downloadService(downloadService: self, didCompleteWithError: error)
    }
}

public protocol DownloaderServiceDelegate: class {
    func downloadService(downloadService: DownloaderService, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    func downloadService(downloadService: DownloaderService, didFinishDownloadingTo location: URL)
    func downloadService(downloadService: DownloaderService, didCompleteWithError error: Error?)
}

extension DownloaderServiceDelegate{
    func downloadService(downloadService: DownloaderService, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
    }
    
    func downloadService(downloadService: DownloaderService, didFinishDownloadingTo location: URL){
    }
    
    func downloadService(downloadService: DownloaderService, didCompleteWithError error: Error?){
    }
}
