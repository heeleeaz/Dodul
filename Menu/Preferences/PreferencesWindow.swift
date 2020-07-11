//
//  PreferenceWindow.swift
//  TouchletMenu
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import AppLib

public class PreferencesWindow: NSWindow{
    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        postInit()
        
        trackScreenViewEvent(screen: self.className) //track screenView
    }
    
    public func postInit(){
        styleMask.remove([.resizable])
        standardWindowButton(.zoomButton)?.isEnabled = false
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        backgroundColor = DarkTheme.touchBarButtonBackgroundColor
    }
}
