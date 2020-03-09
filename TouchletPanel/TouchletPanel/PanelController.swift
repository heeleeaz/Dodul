//
//  ViewController.swift
//  TouchletPanel
//
//  Created by Elias on 06/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

class PanelWindow: NSPanel{
    override var contentView: NSView?{
        didSet{
            setFrame(.zero, display: true)
            setContentSize(frame.size)
        }
    }
}

class PanelWindowController: NSWindowController{
    override func makeTouchBar() -> NSTouchBar?{
        return contentViewController?.makeTouchBar()
    }
}

class PanelViewController: ReadonlyTouchBarController{
    
}

