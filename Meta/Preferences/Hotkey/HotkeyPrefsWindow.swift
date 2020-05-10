//
//  HotkeyPrefsWindow.swift
//  Meta
//
//  Created by Elias on 10/05/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

public class HotkeyPreferenceWindow: NSWindow{
    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        postInit()
        
        trackScreenViewEvent(screen: self.className) //track screenView
    }
    
    public func postInit(){
        backgroundColor = DarkTheme.touchBarButtonBackgroundColor
        
        styleMask.remove([.resizable])
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }
}
