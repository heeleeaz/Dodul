//
//  AppDelegate.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import HotKey

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    public var hotKey: HotKey? {
        didSet {
            guard let hotKey = hotKey else {return}

            hotKey.keyDownHandler = { [weak self] in print("Key")}
        }
    }

    func applicationWillBecomeActive(_ notification: Notification) {
        NSApplication.shared.windows[0].contentView?.enterFullScreenMode()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
