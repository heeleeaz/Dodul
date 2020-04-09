//
//  AppDelegate.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import HotKey
import TouchletCore
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.windows[0].contentView?.enterFullScreenMode()
        
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    
        if GlobalKeybindPreferencesStore.fetch() == nil{
            GlobalKeybindPreferencesStore.save(keyBind: GlobalKeybindPreferences.defaultKeyBind)
        }
        
    
        let launchServiceBundleIdentifier = ProjectBundleResolver.instance.bundleIdentifier(for: .panelLauncher)
        let enabled = SMLoginItemSetEnabled(launchServiceBundleIdentifier as CFString, true)
        Logger.log(text: "\(launchServiceBundleIdentifier) as LoginItem enabled: \(enabled)")
    }
}
