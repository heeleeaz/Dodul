//
//  SkeletonButtonView.swift
//  Touchlet
//
//  Created by Elias on 10/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class SkeletaTouchButtonView: NSButton{
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        bezelColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        
        let borderLayer = CAShapeLayer()
        let d = CGRect(x: 0, y: 0, width: 0, height: 40)
        borderLayer.path = CGPath(roundedRect: d, cornerWidth: 5, cornerHeight: 5, transform: nil)
        borderLayer.strokeColor = NSColor.white.cgColor
        borderLayer.lineDashPattern = [4, 2]
        borderLayer.lineWidth = 1
        borderLayer.fillColor = NSColor.clear.cgColor
        
        layer = borderLayer
        wantsLayer = true
        
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = borderLayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        animation.duration = 1
        animation.repeatCount = .infinity
        layer?.add(animation, forKey: "line")
    }
}
