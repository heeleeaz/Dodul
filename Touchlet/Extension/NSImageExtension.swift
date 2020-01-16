//
//  NSImageExtension.swift
//  Touchlet
//
//  Created by Elias on 15/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSImage {
    var data: Data? {
        return tiffRepresentation
    }
}
