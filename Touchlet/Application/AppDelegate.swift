//
//  AppDelegate.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
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
    
        setupPanelLauncherLoginItem(enabled: true)
        ProjectBundleProvider.instance.launchApplication(project: .panel, launchOptions: .andHide)
    }
    
    func setupPanelLauncherLoginItem(enabled: Bool){
        let identifier = ProjectBundleProvider.instance.bundleIdentifier(for: .panelLauncher)
        let isEnabled = SMLoginItemSetEnabled(identifier as CFString, enabled)
        Logger.log(text: "\(identifier) as LoginItem enabled: \(isEnabled)")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        
    }
}
