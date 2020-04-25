//
//  AppDelegate.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore
import ServiceManagement
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.windows[0].contentView?.enterFullScreenMode()
        
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    
        setupPanelLauncherLoginItem(enabled: true)
        setupGoogleAnalytics()
    }
    
    private func setupGoogleAnalytics(){
        MPGoogleAnalyticsTracker.shared.activate(configuration: MPAnalyticsConfiguration(identifier: "UA-121293848-3"))
        MPAnalyticsTimingManager.shared.beginTracking(timingVariable: Bundle.main.bundleIdentifier ?? "Main")
    }
    
    private func setupPanelLauncherLoginItem(enabled: Bool){
        let identifier = ProjectBundleProvider.instance.bundleIdentifier(for: .panelLauncher)
        let isEnabled = SMLoginItemSetEnabled(identifier as CFString, enabled)
        Logger.log(text: "\(identifier) as LoginItem enabled: \(isEnabled)")
        
        ProjectBundleProvider.instance.launchApplication(project: .panel, launchOptions: .andHide)
    }
    
    func applicationWillTerminate(_ notification: Notification) {MPAnalyticsTimingManager.shared.endTracking()}
}