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
    func enterFullScreenMode(options: NSApplication.PresentationOptions = []){
        let presOptions: NSApplication.PresentationOptions = ([.hideDock,.hideMenuBar])
        let optionsDictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: NSNumber(value: presOptions.union(options).rawValue)]
        view.enterFullScreenMode(NSScreen.main!, withOptions: optionsDictionary)
    }
}
