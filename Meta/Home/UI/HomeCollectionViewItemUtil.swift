//
//  HomeCollectionItemUtil.swift
//  Touchlet
//
//  Created by Elias on 06/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

func itemAppearanceAnimation(_ view: NSView){
    let animation =  CABasicAnimation(keyPath: "backgroundColor")
    animation.fromValue = Theme.touchBarButtonBackgroundColor.highlight(withLevel: 0.1)?.cgColor
    animation.toValue = Theme.touchBarButtonBackgroundColor.cgColor
    animation.duration = 0.7
    view.layer?.add(animation, forKey: "backgroundColor")
}

func insertItems(_ collectionView: NSCollectionView, oldCount: Int, newCount: Int){
    let indexPaths = (oldCount ..< newCount).map{IndexPath(item: $0, section: 0)}
    collectionView.reloadItems(at: Set<IndexPath>(indexPaths))
}

func removeTrailItem(_ collectionView: NSCollectionView){
    collectionView.deleteItems(at: [IndexPath(item: collectionView.numberOfItems(inSection: 0), section: 0)])
}
