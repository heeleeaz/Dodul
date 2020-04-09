//
//  AppDelegate.swift
//  UpdateService
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

@NSApplicationMain
class USAppDelegate: NSObject, NSApplicationDelegate, DownloaderServiceDelegate, NSUserNotificationCenterDelegate {    
    private let downloaderService = DownloaderService.instance
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        downloaderService.delegate = self
    }
    
    func downloadService(downloadService: DownloaderService, didFinishDownloadingTo location: URL) {
        let notification = NSUserNotification()
        notification.identifier = "\(Bundle.main.bundleIdentifier!).appInstallNotification"
        notification.title = String(format: "%@ Update", ProjectBundleProvider.instance.appName(for: .main))
        notification.informativeText = "New version is ready for installation"
        
        notification.hasActionButton = true
        notification.actionButtonTitle = "Install now"
        
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.delegate = self
        notificationCenter.deliver(notification)
    }
    
    func downloadService(downloadService: DownloaderService, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch notification.activationType {
        case .replied:
            let result = try? NSWorkspace.shared.open(downloaderService.downloadedFilePath!, options: .default, configuration: [:])
            ProjectBundleProvider.instance.terminateAppWithAllSubProject()
            
            Logger.log(text: "Application launched \(String(describing: result))")
        default: break
        }
    }
}

