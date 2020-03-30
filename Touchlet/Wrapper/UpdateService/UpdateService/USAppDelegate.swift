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
    
    func deliverAppInstallNotification(){
        let bundle = ProjectBundleResolver.instance.bundle(for: .main)!
        let notification = NSUserNotification()
        notification.identifier = "\(bundle.bundleIdentifier!).appInstallNotification"
        notification.title = String(format: "%@ Update", bundle.infoDictionary["CFBundleName"] as! String)
        notification.informativeText = "New version is ready for installation"
        
        notification.hasActionButton = true
        notification.actionButtonTitle = "Install now"
        
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.delegate = self
        notificationCenter.deliver(notification)
    }
    
    func downloadService(downloadService: DownloaderService, didFinishDownloadingTo location: URL) {
        
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        switch notification.activationType {
        case .replied:
            try NSWorkspace.shared.open(downloaderService.downloadedFilePath!, options: .default, configuration: [:])
            ProjectBundleResolver.instance.terminateAppWithAllSubProject()
        default: break
        }
    }
}

