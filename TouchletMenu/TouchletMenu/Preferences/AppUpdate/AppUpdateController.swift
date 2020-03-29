//
//  AppUpdateController.swift
//  TouchletMenu
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import TouchletCore

class AppUpdateController: NSViewController{
    private lazy var downloadButton = DownloadButton(title: "", target: self, action: #selector(downloadButtonClicked))
    
    override func loadView() {
        view = NSView()
        view.addSubview(downloadButton)
        
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     downloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadButton.downloadState = .normal
    }
    
    @objc private func downloadButtonClicked(){
        let api = UpdateAPI()
        
        self.setButtonState(.updating)
        api.requestVersion { (data, error) in
            guard
                let data = data?.data(using: .utf8),
                let versionInfo = try? JSONDecoder().decode(VersionInfo.self, from: data),
                let serverBundleVersion = Int(versionInfo.buildVersion ?? "-1"),
                let fileDownloadURL = versionInfo.downloadLink,
                let bundleVersion = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-1") else {
                    self.downloadButton.downloadState = .normal
                    Logger.log(text: "error reading or decoding data from server")
                    return
            }
            
            if bundleVersion < serverBundleVersion{
                self.setButtonState(.updating)
                DispatchQueue.main.async {
                    let downloader = DownloaderController.presentAsWindowKeyAndOrderFront(nil)
                    downloader.beginDownload(fileURL: URL(string: fileDownloadURL)!)
                }
                Logger.log(text: "update required")
            }else{
                Logger.log(text: "app is up to date")
                self.setButtonState(.updated)
            }
        }
    }
    
    private func setButtonState(_ state: DownloadButton.DownloadState){
        DispatchQueue.main.async {self.downloadButton.downloadState = state}
    }
}


fileprivate class DownloadButton: NSButton{
    private var currentState: DownloadState?
    
    var downloadState: DownloadState = .normal {
        didSet{
            if currentState == downloadState {
                return
            }
            
            switch downloadState {
            case .updating:
                title = "Checking for update.."
                isEnabled = false
            case .updated:
                title = "✓ App is up to date"
                isEnabled = true
            default:
                title = "Check for update"
                isEnabled = true
            }
            currentState = downloadState
        }
    }
    
    enum DownloadState{case updating, updated, normal}
}
