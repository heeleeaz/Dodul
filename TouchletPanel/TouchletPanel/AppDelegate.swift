//
//  AppDelegate.swift
//  TouchletPanel
//
//  Created by Elias on 06/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import HotKey
import TouchletCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var hotKey: HotKey? {
        didSet {
            hotKey?.keyDownHandler = {
                Logger.log(text: "showing TouchletPanel from HotKey context")
                if let window = NSApplication.shared.windows.first{
                    window.makeKeyAndOrderFront(nil)
                    window.orderFrontRegardless()
                }
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Logger.log(text: "TouchletPanel launched")
        
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
        
        if let key = GlobalKeybindPreferencesStore.fetch(){
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: key.keyCode, carbonModifiers: key.carbonFlags))
        }else{
            let defKey = GlobalKeybindPreferences.defaultKeyBind
            
            GlobalKeybindPreferencesStore.save(keyBind: defKey)
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: defKey.keyCode, carbonModifiers: defKey.carbonFlags))
        }
        
        let startedAtLogin = NSWorkspace.shared.runningApplications.contains{$0.bundleIdentifier == Constants.helperAppBundleIdentifier}
        if startedAtLogin{
            //terminate helper app
            DistributedNotificationCenter.default().postNotificationName(Constants.KILLAPP, object: Bundle.main.bundleIdentifier, userInfo: nil, options: .deliverImmediately)
        }
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate{
    struct Constants {
        static let helperAppBundleIdentifier = "com.heeleeaz.touchlet.panel.LaunchHelper"
        static let KILLAPP = NSNotification.Name("KILLAPP")
    }
}
