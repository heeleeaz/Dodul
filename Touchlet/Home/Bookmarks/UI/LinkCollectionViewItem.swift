//
//  AddBookmarkCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import FavIcon

class LinkCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("LinkCollectionViewItem")
    
    private let cache = Cache<String, Data>()
    
    var link: Link!{didSet{if isViewLoaded { updateView() }}}
        
    private func updateView(){
        textField?.stringValue = link.displayTitle ?? ""
        
        FaviconImageProvider.instance.load(url: link.url, completion: { (image, _) in
            if let image = image {self.imageView?.image = image}
        })
    }
}
