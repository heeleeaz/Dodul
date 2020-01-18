//
//  NSCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 12/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSCollectionView{
    var contentSize: NSSize?{
        return collectionViewLayout?.collectionViewContentSize
    }
    
    func hideVerticalScrollView() {
        if let scrollBar = enclosingScrollView{
            scrollBar.verticalScroller = nil
        }
    }
}
