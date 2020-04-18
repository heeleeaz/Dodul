//
//  AppDelegate.swift
//  TouchletPanel
//
//  Created by Elias on 06/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var hotKey: HotKey?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.2, *) {NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true}
        
        setupHotKey()
        
        let launchHelperIdentifer = ProjectBundleProvider.instance.bundleIdentifier(for: .panelLauncher)
        if (NSWorkspace.shared.runningApplications.contains{$0.bundleIdentifier == launchHelperIdentifer}){
            //terminate helper app
            DistributedNotificationCenter.default().postNotificationName(.killApp, object: Bundle.main.bundleIdentifier, userInfo: nil, options: .deliverImmediately)
        }
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(setupHotKey), name: .hotKeySetup, object: ProjectBundleProvider.instance.bundleIdentifier(for: .main))
        
        setupGoogleAnalytics()
    }
    
    private func setupGoogleAnalytics(){
        MPGoogleAnalyticsTracker.shared.activate(configuration: MPAnalyticsConfiguration(identifier: "UA-121293848-3"))
    }
    
    @objc private func setupHotKey(){
        if let key = GlobalKeybindPreferencesStore.fetch(){
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: key.keyCode, carbonModifiers: key.carbonFlags))
        }else{
            let defKey = GlobalKeybindPreferences.defaultKeyBind
            GlobalKeybindPreferencesStore.save(keyBind: defKey)
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: defKey.keyCode, carbonModifiers: defKey.carbonFlags))
        }
        
        hotKey?.keyDownHandler = {
            Logger.log(text: "showing TouchletPanel from HotKey context")
            if let window = NSApplication.shared.windows.first{
                window.makeKeyAndOrderFront(nil); window.orderFrontRegardless()
            }
        }
    }
}
