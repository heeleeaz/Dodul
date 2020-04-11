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
        //check if the file is not already in the download queue. if it is not,
        //then proceed to download. the delegate is set in either cases so as to
        //receive progress.
        downloadService.findTask(with: fileURL) {
            if $0 == nil{self.downloadService.downloadFile(fileURL: fileURL)}
        }
        
        self.downloadService.delegate = self
        if isViewLoaded{progressLabel.stringValue = "Preparing to download"}
    }
    
    @IBAction func continueInBackgroundClicked(_ sender: NSButton) {
        guard let downloadTask = downloadService.downloadTask else {return}
        
        switch downloadTask.state {
        case .running:
            let identifier = ProjectBundleProvider.instance.bundleIdentifier(for: .updateService)
            NSWorkspace.shared.launchApplication(withBundleIdentifier: identifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
            view.window?.close()
        case .completed:
            do{
                try NSWorkspace.shared.open(downloadService.downloadedFilePath!, options: .default, configuration: [:])
                ProjectBundleProvider.instance.terminateAppWithAllSubProject()
            }catch{
                Logger.log(items: "Error: \(error.localizedDescription)")
            }
        default: break
        }
    }
}

extension DownloaderController: DownloaderServiceDelegate{
    func downloadService(downloadService: DownloaderService, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.progressLabel.textColor = .white
            self.progressLabel.stringValue = "Download completed"
            self.continueInBackgroundButton.title = "Install update now"
        }
    }
    
    func downloadService(downloadService: DownloaderService, didCompleteWithError error: Error?) {
        if let error = error{
            DispatchQueue.main.async {
                self.progressLabel.textColor = .red
                self.progressLabel.stringValue = "download failed, please try again"
            }
            
            Logger.log(items: "Error: \(error.localizedDescription)")
        }
    }
    
    func downloadService(downloadService: DownloaderService, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.progressIndicator.maxValue = Double(totalBytesExpectedToWrite)
            self.progressIndicator.doubleValue = Double(totalBytesWritten)
            
            let totalBytesWrittenString = ByteCountFormatter.string(fromByteCount: totalBytesWritten, countStyle: .file)
            let totalBytesExpectedToWriteString = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
            self.progressLabel.stringValue = "Downloaded \(totalBytesWrittenString) of \(totalBytesExpectedToWriteString)"
        }
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
