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
        if let image = SpotlightRepository.findAppIcon(bundleIdentifier: spotlight.bundleIdentifier){
            imageView?.image = image
        }
    }
}
