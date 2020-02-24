//
//  UIColorExtension.swift
//  project4
//
//  Created by Elias on 11/12/2019.
//  Copyright © 2019 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSColor {
    public func combine(withColor other: NSColor, ratio: CGFloat) -> NSColor {
        let otherRatio = 1 - ratio
        let red = (redComponent * ratio) + (other.redComponent * otherRatio)
        let green = (greenComponent * ratio) + (other.greenComponent * otherRatio)
        let blue = (blueComponent * ratio) + (other.blueComponent * otherRatio)
        let alpha = (alphaComponent * ratio) + (other.alphaComponent * otherRatio)
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public var redComponent: CGFloat {
        var redComponent: CGFloat = 0
        getRed(&redComponent, green: nil, blue: nil, alpha: nil)
        return redComponent
    }
    
    public var greenComponent: CGFloat {
        var greenComponent: CGFloat = 0
        getRed(nil, green: &greenComponent, blue: nil, alpha: nil)
        return greenComponent
    }
    
    public var blueComponent: CGFloat {
        var blueComponent: CGFloat = 0
        getRed(nil, green: nil, blue: &blueComponent, alpha: nil)
        return blueComponent
    }
    
    public var alphaComponent: CGFloat {
        var alphaComponent: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &alphaComponent)
        return alphaComponent
    }
}

extension NSColor{
    static var touchBarButtonColor: NSColor{return NSColor(named: "TouchBarColor") ?? NSColor.clear}
    static var hotKeyAttributeTextForegroundColor = NSColor.white
    static var hotKeyAttributeTextBackgroundColor = NSColor.darkGray
}
