//
//  BorderlessWindow.swift
//  Touchlet
//
//  Created by Elias on 26/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

public class PreferencesWindow: NSWindow{
    override public var canBecomeMain: Bool{return true}
    
    override public var canBecomeKey: Bool{return true}
    
    public override var hasTitleBar: Bool{return true}
}
