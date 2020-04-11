//
//  NSWindowExtension.swift
//  Touchlet
//
//  Created by Elias on 25/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

extension NSWindow{
    func enableBlur(){
        self.isOpaque = false
        self.backgroundColor = NSColor(calibratedWhite: 1.0, alpha: 0.5)
    }
}
