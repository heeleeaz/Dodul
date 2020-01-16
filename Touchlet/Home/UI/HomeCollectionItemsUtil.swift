//
//  HomeCollectionViewController.swift
//  Touchlet
//
//  Created by Elias on 16/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

func fitSize(view: NSView, collectionView: NSCollectionView){
    DispatchQueue.main.async {
        let collectionVH = collectionView.heightConstaint?.constant ?? 0
        let contentHeight = collectionView.contentSize?.height ?? 0
        view.heightConstaint?.constant += (contentHeight - collectionVH)
    }
}
