//
//  HomeCollectionViewController.swift
//  Touchlet
//
//  Created by Elias on 16/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

func collectionItemDraggingImageComponent(collectionItemView: NSView, iconImage: NSImage?) -> [NSDraggingImageComponent]{
    let background = NSDraggingImageComponent(key: .icon)
    background.contents = NSImage(named: "TouchBarButtonImageBackground")
    background.frame = NSRect(x: 0, y: (collectionItemView.frame.height/2), width: 90, height: 40)
    
    let icon = NSDraggingImageComponent(key: .icon)
    icon.contents = iconImage
    icon.frame = NSRect(x: 29, y: (collectionItemView.frame.height/2)+4, width: 32, height: 32)
    
    return [background, icon]
}
