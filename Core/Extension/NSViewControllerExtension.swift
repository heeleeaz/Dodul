//
//  NSViewControllerExtension.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

@nonobjc extension NSViewController {
    func addChildHelper(_ child: NSViewController, view: NSView? = nil) {
        addChild(child)
        (view ?? self.view).addSubview(child.view)
    }
    
    func removeChildHelper(view: NSView? = nil) {
        (view ?? self.view).removeFromSuperview()
        removeFromParent()
    }
}


extension NSViewController{
    public func presentAsTooltop(_ viewController: NSViewController, anchor: NSView){
        present(viewController,
                asPopoverRelativeTo: .zero,
                of: anchor,
                preferredEdge: NSRectEdge(rawValue: 0)!,
                behavior: .applicationDefined)
    }
}
