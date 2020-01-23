//
//  TouchBarCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 23/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier(String(describing: TouchBarCollectionViewItem.self))
    
    var touchBarItem: TouchBarItem!{
        didSet{
            if let image = touchBarItem.iconImage{
                imageView?.image = image
            }
        }
    }
}
