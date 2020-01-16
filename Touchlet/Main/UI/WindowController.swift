//
//  WindowController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController{
    let label = NSTouchBarItem.Identifier("com.TouchBarCatalog.TouchBarItem.label")
    
    override func windowDidLoad() {
        guard let window = window else {
            return
        }

        
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.masksToBounds = true
        window.contentView?.layer?.cornerRadius = 20
        window.isOpaque = false
        window.backgroundColor = .clear
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier =
            NSTouchBar.CustomizationIdentifier("com.TouchBarCatalog.windowTouchBar")
        touchBar.defaultItemIdentifiers = [label, .otherItemsProxy]
        return touchBar
    }
}

// MARK: - NSTouchBarDelegate

@available(OSX 10.12.2, *)
extension WindowController: NSTouchBarDelegate {
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)
        let label = NSTextField(labelWithString: NSLocalizedString("Catalog", comment: ""))
        custom.view = label
        return custom
    }
}

