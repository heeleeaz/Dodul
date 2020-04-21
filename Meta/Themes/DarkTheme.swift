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
    static var hotkeyTextColor = NSColor(named: "EditingHotkeyTextColor")!
    static var hotkeyBackgroundColor = NSColor(named: "HotKeyBackgroundColor")!
    
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
