//
//  WindowController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController{
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.setFrameAutosaveName("WindowAutosave")
        
        NotificationCenter.default.addObserver(self, selector: #selector(touchBarItemDidChanged), name: .TouchBarItem, object: nil)
    }
    
    @objc private func touchBarItemDidChanged(notification: NSNotification){
        refreshTouchBar()
    }
    
    deinit {
        UserDefaults.touchBarSuite.removeObserver(self, forKeyPath: TouchBarItemUserDefault.Keys.touchBarItemKey)
    }
}

