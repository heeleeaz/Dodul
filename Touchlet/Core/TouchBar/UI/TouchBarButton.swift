//
//  TouchBarButton.swift
//  Touchlet
//
//  Created by Elias on 21/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarButton: NSButton{
    override var intrinsicContentSize: NSSize{
        return NSSize(width: 72, height: 30)
    }
}
