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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.windows[0].contentView?.enterFullScreenMode()
        
        if #available(OSX 10.12.2, *) {NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true}
    
        setupMetaPanel(enabled: true)
        setupGoogleAnalytics()
    }
    
    private func setupGoogleAnalytics(){
        guard let GAIdentifier = Bundle.main.object(forInfoDictionaryKey: "GA_IDENTIFIER") as? String else{
            fatalError("GA_IDENTIFIER is not set")
        }
        
        MPGoogleAnalyticsTracker.shared.activate(configuration: MPAnalyticsConfiguration(identifier: GAIdentifier))
        MPAnalyticsTimingManager.shared.beginTracking(timingVariable: Bundle.main.bundleIdentifier ?? "Main")
    }
    
    private func setupMetaPanel(enabled: Bool){
        let identifier = Global.shared.bundleIdentifier(for: .panel)
        let isEnabled = SMLoginItemSetEnabled(identifier as CFString, enabled)
        Logger.log(text: "\(identifier) as LoginItem enabled: \(isEnabled)")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        MPAnalyticsTimingManager.shared.endTracking()
    }
}
