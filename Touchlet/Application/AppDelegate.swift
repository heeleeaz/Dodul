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
    func applicationWillBecomeActive(_ notification: Notification) {
        NSApplication.shared.windows[0].contentView?.enterFullScreenMode()
        
        let launchHelperIdentifer = ProjectBundleResolver.instance.bundleIdentifier(for: .panelLauncher)
        SMLoginItemSetEnabled(launchHelperIdentifer as CFString, true)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    
        if GlobalKeybindPreferencesStore.fetch() == nil{
            GlobalKeybindPreferencesStore.save(keyBind: GlobalKeybindPreferences.defaultKeyBind)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
