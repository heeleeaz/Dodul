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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillBecomeActive(_ notification: Notification) {
        NSApplication.shared.windows[0].contentView?.enterFullScreenMode()
        
        Global.groupIdPrefix = projectGroupIdPrefix
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
    
    private var projectGroupIdPrefix: String {
        let bundle = ProjectBundleResolver.instance.bundle(for: .main)
        let groupIdPrefixKey = "GroupIdentifierPrefix"
        guard let groupIdPrefix = bundle?.object(forInfoDictionaryKey: groupIdPrefixKey) as? String else {
            fatalError("Info.plist must contain a \"\(groupIdPrefixKey)\" entry with a string value")
        }
    
        return groupIdPrefix
    }
}
