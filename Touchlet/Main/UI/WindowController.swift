//
//  WindowController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController{
    let label = NSTouchBarItem.Identifier("\(Global.groupIdPrefix).label")
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.setFrameAutosaveName("WindowAutosave")
    }
}

