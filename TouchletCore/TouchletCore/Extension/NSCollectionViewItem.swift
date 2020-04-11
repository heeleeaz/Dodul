//
//  NSCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 12/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

extension NSCollectionView{
    public var contentSize: NSSize?{
        return collectionViewLayout?.collectionViewContentSize
    }
    
    @IBInspectable public var hideVerticalScrollView: Bool {
        set{
            enclosingScrollView?.verticalScroller = nil
        }
        get{
            return enclosingScrollView?.verticalScroller != nil
        }
    }
}
