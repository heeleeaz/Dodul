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

class HomeOptionCollectionItem: CellItem{
}
