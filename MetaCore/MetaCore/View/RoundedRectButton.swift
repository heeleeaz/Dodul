//
//  RoundRectButton.swift
//  TouchletCore
//
//  Created by Elias on 19/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

@IBDesignable public class RoundedRectButton: NSButton{
    @IBInspectable var hightlightColor: NSColor?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        postInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        postInit()
    }
        
    private func postInit(){
        cornerRadius = max(frame.width, frame.height) / 2
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil))
        
        imageScaling = .scaleProportionallyDown
        imagePosition = .imageOnly
    }
    
    override public func mouseEntered(with event: NSEvent) {
        _backgroundColor = hightlightColor
    }
    
    override public func mouseExited(with event: NSEvent) {
        _backgroundColor = .clear
    }
}
