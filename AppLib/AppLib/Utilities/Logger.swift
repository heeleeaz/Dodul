//
//  Logger.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

public struct Logger {
    
    public static func log(text: String) {
        #if DEBUG
        print(text, separator: " ", terminator: "\n")
        #endif
    }
    
    public static func log(items: Any...) {
        #if DEBUG
        debugPrint(items, separator: " ", terminator: "\n")
        #endif
    }
}
