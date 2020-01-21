//
//  AppDelegate.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillBecomeActive(_ notification: Notification) {
        if let screenFrame = NSScreen.main?.frame {
            let window = NSApplication.shared.windows[0]
            window.backgroundColor = NSColor.clear
            window.setFrame(screenFrame, display: true)
            window.setContentSize(screenFrame.size)
            window.contentView?.enterFullScreenMode(NSScreen.main!, withOptions: nil)
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

