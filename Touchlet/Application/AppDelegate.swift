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

            hotKey.keyDownHandler = { [weak self] in
               print("Key")
            }
        }
    }

    func applicationWillBecomeActive(_ notification: Notification) {
        if let screenFrame = NSScreen.main?.frame {
            let window = NSApplication.shared.windows[0]
            window.setFrame(screenFrame, display: true)
            window.setContentSize(screenFrame.size)
            
            window.contentViewController?.enterFullScreenMode()
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
        
        let cache = (try? Cache<String, GlobalKeybindPreferences>.loadFromDisk(withName: HotKeyStore.Constant.KEYCODE_CACHE_KEY)) ?? Cache<String, GlobalKeybindPreferences>()
        
        if let key = cache.value(forKey: HotKeyStore.Constant.KEYCODE_CACHE_KEY){
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: key.keyCode, carbonModifiers: key.carbonFlags))
        }else{
            let defKey = GlobalKeybindPreferences.defaultKeyBind
            cache.insert(defKey, forKey: HotKeyStore.Constant.KEYCODE_CACHE_KEY)
            try? cache.saveToDisk(withName: HotKeyStore.Constant.KEYCODE_CACHE_KEY)
                           
            hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: defKey.keyCode, carbonModifiers: defKey.carbonFlags))
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
