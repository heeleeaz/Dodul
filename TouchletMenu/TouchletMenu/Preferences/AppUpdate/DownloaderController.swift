//
//  DownloadController.swift
//  TouchletMenu
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import TouchletCore

class DownloaderController: NSViewController, NibLoadable{
    private let downloadService = DownloaderService.instance

    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var progressLabel: NSTextField!
    @IBOutlet weak var continueInBackgroundButton: NSButton!
    
    func beginDownload(fileURL: URL){
        downloadService.downloadFile(fileURL: fileURL)
        downloadService.delegate = self
    }
    
    @IBAction func continueInBackgroundClicked(_ sender: NSButton) {
        guard let downloadTask = downloadService.downloadTask else {return}
        
        switch downloadTask.state {
        case .running:
            try? ProjectBundleResolver.instance.launch(project: .updateService)
        case .completed:
            do{
                try NSWorkspace.shared.open(downloadService.downloadedFilePath!, options: .default, configuration: [:])
                ProjectBundleResolver.instance.terminateAppWithAllSubProject()
            }catch{
                Logger.log(text: error.localizedDescription)
            }
        default: break
        }
    }
}

extension DownloaderController: DownloaderServiceDelegate{
    func downloadService(downloadService: DownloaderService, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.progressIndicator.maxValue = Double(totalBytesExpectedToWrite)
            self.progressIndicator.doubleValue = Double(totalBytesWritten)
            
            let totalBytesWrittenString = ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .file)
            let totalBytesExpectedToWriteString = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
            self.progressLabel.stringValue = "Downloaded \(totalBytesWrittenString) of \(totalBytesExpectedToWriteString)"
        }
    }
    
    func downloadService(downloadService: DownloaderService, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.progressLabel.stringValue = "Download completed"
            self.continueInBackgroundButton.title = "Install update now"
        }
    }
    
    func downloadService(downloadService: DownloaderService, didCompleteWithError error: Error?) {
        print("download error \(error)")
    }
}

extension DownloaderController{
    static func presentAsWindowKeyAndOrderFront(_ sender: Any?) -> DownloaderController{
        let controller = createFromNib()!
        let window = PreferencesWindow(contentViewController: controller)
            
        if let screenSize = NSScreen.main?.frame.size{
            window.setFrameOrigin(NSPoint.center(a: screenSize, b: window.frame.size))
        }
            
        window.makeKeyAndOrderFront(sender)
        
        return controller
    }
}
