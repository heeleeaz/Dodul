//
//  CollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import Core

class AppCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("AppCollectionViewItem")
    
    var spotlight: SpotlightItem!{didSet{if isViewLoaded { updateView()}}}
    
    private func updateView(){
        textField?.stringValue = spotlight.displayName ?? ""
        imageView?.image = SpotlightRepository.findAppIcon(bundleIdentifier: spotlight.bundleIdentifier)
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent]{
        return collectionItemDraggingImageComponent(collectionItemView: self.view, iconImage: self.imageView?.image)
    }
}