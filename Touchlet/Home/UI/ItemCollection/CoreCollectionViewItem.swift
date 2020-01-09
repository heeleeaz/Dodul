//
//  CollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class CoreCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("CoreCollectionViewItem")

    var icon: NSImage! {
        didSet{
            imageView?.image = icon
        }
    }
    
    var label: String! {
        didSet{
            textField?.stringValue = label
        }
    }
}
