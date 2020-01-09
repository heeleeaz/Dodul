//
//  NSViewControllerExtension.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

@nonobjc extension NSViewController {
    func addChildHelper(_ child: NSViewController, frame: CGRect? = nil) {
        addChild(child)
        if let frame = frame {child.view.frame = frame}
        view.addSubview(child.view)
    }
    
    func removeChildHelper() {
        view.removeFromSuperview()
        removeFromParent()
    }
}
