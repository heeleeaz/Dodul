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
