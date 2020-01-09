//
//  UIViewExtension.swift
//  project4
//
//  Created by Elias on 13/12/2019.
//  Copyright © 2019 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSView {
    var backgroundColor: NSColor? {
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
        get {
            if let color = layer?.backgroundColor { return NSColor(cgColor: color)} else {
                return nil
            }
        }
    }
}
