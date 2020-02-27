//
//  PreferenceWindow.swift
//  Touchlet
//
//  Created by Elias on 25/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

public class MainWindow: NSWindow{    
    override public var contentView: NSView?{
        didSet{
            if let frame = NSScreen.main?.frame{
                setFrame(frame, display: true)
                setContentSize(frame.size)
            }
        }
    }
}

