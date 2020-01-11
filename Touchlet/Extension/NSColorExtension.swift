//
//  UIColorExtension.swift
//  project4
//
//  Created by Elias on 11/12/2019.
//  Copyright © 2019 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSColor {
    
    public static var reallyBlack: NSColor {
        return NSColor(red: 25.0 / 255.0, green: 25.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
    }
    
    public static var nearlyBlackLight: NSColor {
        return NSColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    
    public static var nearlyBlack: NSColor {
        return NSColor(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    }
    
    public static var charcoalGrey: NSColor {
        return NSColor(red: 68.0 / 255.0, green: 68.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }
    
    public static var greyishBrown: NSColor {
        return NSColor(red: 85.0 / 255.0, green: 85.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    }
    
    public static var greyishBrown2: NSColor {
        return NSColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }
    
    public static var greyish: NSColor {
        return NSColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    }
    
    public static var greyish2: NSColor {
        return NSColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    }
    
    public static var greyish3: NSColor {
        return NSColor(red: 136.0 / 255.0, green: 136.0 / 255.0, blue: 136.0 / 255.0, alpha: 1.0)
    }
    
    public static var lightGreyish: NSColor {
        return NSColor(red: 234.0 / 255.0, green: 234.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0)
    }
    
    public static var darkGreyish: NSColor {
        return NSColor(red: 73.0 / 255.0, green: 73.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
    }
    
    public static var lightMercury: NSColor {
        return NSColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    
    public static var mercury: NSColor {
        return NSColor(red: 229.0 / 255.0, green: 229.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
    }
    
    public static var cornflowerBlue: NSColor {
        return NSColor(red: 103.0 / 255.0, green: 143.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    public static var cornflowerDark: NSColor {
        return NSColor(red: 80.0 / 255.0, green: 120.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
    }
    
    public static var skyBlue: NSColor {
        return NSColor(red: 66.0 / 255.0, green: 191.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }
    
    public static var skyBlueLight: NSColor {
        return NSColor(red: 120.0 / 255.0, green: 210.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    public static var midGreen: NSColor {
        return NSColor(red: 63.0 / 255.0, green: 161.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }
    
    public static var orange: NSColor {
        return NSColor(red: 222.0 / 255.0, green: 88.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    
    public static var orangeLight: NSColor {
        return NSColor(red: 255.0 / 255.0, green: 135.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
    }
    
    public static var nearlyWhiteLight: NSColor {
        return NSColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    public static var nearlyWhite: NSColor {
        return NSColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
}

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
