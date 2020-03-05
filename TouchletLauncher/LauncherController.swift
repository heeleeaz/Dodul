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
    override var contentView: NSView?{
        didSet{
            setFrame(.zero, display: true)
            setContentSize(frame.size)
        }
    }
}

class LauncherWindowController: NSWindowController {
    override func makeTouchBar() -> NSTouchBar? {
        return contentViewController?.makeTouchBar()
    }
}

class LauncherController: ReadonlyTouchBarController{
}
