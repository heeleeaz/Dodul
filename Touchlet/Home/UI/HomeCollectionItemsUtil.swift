//
//  HomeCollectionViewController.swift
//  Touchlet
//
//  Created by Elias on 16/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

func compactSize(ofView view: NSView, _ collectionView: NSCollectionView, append: Int = -1){
    DispatchQueue.main.async {
        let contentHeight = collectionView.contentSize?.height ?? 0
        let diff = append == -1 ? abs(contentHeight - view.frame.size.height) : 60
        let newViewHight = contentHeight + diff
        
        view.heightConstaint?.constant = newViewHight
        view.setFrameSize(NSSize(width: view.frame.width, height: newViewHight))
    }
}

func collectionItemDraggingImageComponent(collectionItemView: NSView, iconImage: NSImage?) -> [NSDraggingImageComponent]{
    let background = NSDraggingImageComponent(key: .icon)
    background.contents = NSImage(named: "TouchBarButtonImageBackground")
    background.frame = NSRect(x: 0, y: (collectionItemView.frame.height/2), width: 90, height: 40)
    
    let icon = NSDraggingImageComponent(key: .icon)
    icon.contents = iconImage
    icon.frame = NSRect(x: 29, y: (collectionItemView.frame.height/2)+4, width: 32, height: 32)
    
    return [background, icon]
}
