//
//  NSViewControllerExtension.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

@nonobjc extension NSViewController {
    public func addChildHelper(_ child: NSViewController, view: NSView? = nil) {
        addChild(child)
        (view ?? self.view).addSubview(child.view)
        
        if let view = view{child.view.setFrameSize(view.frame.size)}
    }
    
    public func removeChildHelper(view: NSView? = nil) {
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

extension NSViewController{
    public func dispatchSelector(_ sender: Any){
        
    }
}
