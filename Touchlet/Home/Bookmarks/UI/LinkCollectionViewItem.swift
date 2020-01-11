//
//  AddBookmarkCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class LinkCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("LinkCollectionViewItem")
    
    var link: Link!{didSet{if isViewLoaded { updateView() }}}
    
    private func updateView(){
        textField?.stringValue = link.displayTitle ?? ""
    }
}
