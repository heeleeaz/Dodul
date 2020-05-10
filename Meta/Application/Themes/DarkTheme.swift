//
//  Colors.swift
//  Touchlet
//
//  Created by Elias on 04/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

class DarkTheme: Theme {
    static var hotkeyBackgroundColor = NSColor(named: "HotKeyBackgroundColor")!
    static var quickObserverColor = NSColor(named: "QuickObserverColor")!
    static var quickLaunchPreferenceContainerBackgroundColor = NSColor(named: "QLPContainerBackgroundColor")!
    static var borderColor = NSColor(named: "BorderColor")!
    static var textColor = NSColor(named: "TextColor")
    static var buttonTextColor = NSColor(named: "ButtonTextColor")

    struct Fonts {
        static func sourceSansProRegular(with size: CGFloat) -> NSFont {
            guard let font = NSFont(name: "SourceSansPro-Regular", size: size) else {
                fatalError("Failed to load the 'SourceSansPro-Regular' font")
            }
            return font
        }
        
        static func sourceSansProLight(with size: CGFloat) -> NSFont {
            guard let font = NSFont(name: "SourceSansPro-Light", size: size) else {
                fatalError("Failed to load the 'SourceSansPro-Light' font")
            }
            return font
        }
    }
}
