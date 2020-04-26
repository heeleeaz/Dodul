//
//  AppDelegate.swift
//  TouchletPanel
//
//  Created by Elias on 06/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import MetaCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var hotKey: HotKey?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.2, *) {NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true}
        
        setupHotKey()
        setupGoogleAnalytics()
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(killApp), name: .killApp, object: nil)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(setupHotKey), name: .hotKeySetup, object: nil)
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
                window.makeKeyAndOrderFront(nil)
                window.orderFrontRegardless()
            }
        }
    }
    
    private func setupGoogleAnalytics(){
        guard let GAIdentifier = Bundle.main.object(forInfoDictionaryKey: "GA_IDENTIFIER") as? String else{
            fatalError("GA_IDENTIFIER is not set")
        }
        
        MPGoogleAnalyticsTracker.shared.activate(configuration: MPAnalyticsConfiguration(identifier: GAIdentifier))
    }
    
    @objc private func killApp(){NSApp.terminate(nil)}
}
