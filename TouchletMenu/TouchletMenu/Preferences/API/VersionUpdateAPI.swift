//
//  UpdateAPI.swift
//  TouchletMenu
//
//  Created by Elias on 23/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import TouchletCore

class VersionUpdateAPI{
    func requestVersion(_ completionHandler: @escaping (String?, Error?)->()){
        let request = NetworkRequest()
        request.setURL(url: "https://us-central1-touchlet-11807.cloudfunctions.net/lastestVersion")
        request.request { (data, error) in
            if error != nil || data == nil{
                completionHandler(nil, error)
            }else{
                completionHandler(String(data: data!, encoding: .utf8), nil)
            }
        }
    }
}


class VersionDownloadRequestAPI: NSObject, URLSessionDownloadDelegate{
    func downloadAppFile(fileURL: URL){
        let config = URLSessionConfiguration.background(withIdentifier: "AppDownload")
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let backgroundTask = session.downloadTask(with: fileURL)
        backgroundTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do{
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let savedURL = documentsURL.appendingPathComponent(location.lastPathComponent)
            try FileManager.default.moveItem(at: location, to: savedURL)
        }catch{
            
        }
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    
}
