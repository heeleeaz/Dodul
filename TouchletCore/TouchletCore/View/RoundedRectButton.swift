//
//  RoundRectButton.swift
//  TouchletCore
//
//  Created by Elias on 19/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

class RoundedRectButton: NSButton{
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        postInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        postInit()
    }
    
    override func awakeFromNib() {
        postInit()
    }
    
    private func postInit(){
        cornerRadius = max(frame.width, frame.height) / 2
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil))        
    }
    
    override func mouseEntered(with event: NSEvent) {
        
    }
    
    override func mouseExited(with event: NSEvent) {
        
    }
}
