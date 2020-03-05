//
//  TouchLayoutWindow.swift
//  Touchlet
//
//  Created by Elias on 03/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarLayoutWindow: NSPanel {
}

class TouchBarLayoutWindowController: NSWindowController {
    override func makeTouchBar() -> NSTouchBar? {
        return contentViewController?.makeTouchBar()
    }
}

class TouchBarLayoutController: ReadonlyTouchBarController{
}
