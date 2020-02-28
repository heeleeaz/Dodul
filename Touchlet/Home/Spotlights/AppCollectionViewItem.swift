//
//  CollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class AppCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("AppCollectionViewItem")
    
    var spotlight: SpotlightItem!{didSet{if isViewLoaded { updateView()}}}
    
    private func updateView(){
        textField?.stringValue = spotlight.displayName ?? ""
        imageView?.image = SpotlightRepository.findAppIcon(bundleIdentifier: spotlight.bundleIdentifier)
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent]{
        let background = NSDraggingImageComponent(key: .icon)
        background.contents = NSImage(named: "TouchBarButtonImageBackground")
        background.frame = NSRect(x: 0, y: (view.frame.height/2), width: 90, height: 40)
        
        let icon = NSDraggingImageComponent(key: .icon)
        icon.contents = imageView?.image
        icon.frame = NSRect(x: 29, y: (view.frame.height/2)+4, width: 32, height: 32)
        
        return [background, icon]
    }
}
