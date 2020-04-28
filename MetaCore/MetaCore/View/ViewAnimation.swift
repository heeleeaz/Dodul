//
//  ViewAnimation.swift
//  MetaCore
//
//  Created by Elias on 28/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class ViewAnimation{
    public static func backgroundFlashAnimation(_ view: NSView, from: NSColor?, to: NSColor?){
        let animation =  CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = from?.cgColor
        animation.toValue = to?.cgColor
        animation.duration = 0.7
        view.layer?.add(animation, forKey: "backgroundColor")
    }
}
