//
//  TouchLayoutWindow.swift
//  Touchlet
//
//  Created by Elias on 03/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import Core

class LauncherWindow: NSPanel {
    
    override var canBecomeKey: Bool{return true}
    
    override var canBecomeMain: Bool{return true}
    
    override var acceptsFirstResponder: Bool{return true}
}

class LauncherWindowController: NSWindowController {
    override func makeTouchBar() -> NSTouchBar? {
        return contentViewController?.makeTouchBar()
    }
}

class LauncherController: ReadonlyTouchBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        
        print("keyDown")
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        print("mouseDown")
    }
}
