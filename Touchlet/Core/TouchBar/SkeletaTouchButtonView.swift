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
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
//        borderColor = NSColor(named: "SkeletaTouchButtonBorderColor")
//        borderWidth = 1
//        cornerRadius = 5
        
//        wantsLayer = true
//        let border = CAShapeLayer()
//        border.strokeColor = NSColor(named: "SkeletaTouchButtonBorderColor")?.cgColor
//        border.lineDashPattern = [2, 2]
//        border.frame =  bounds
//        border.fillColor = nil
//        border.path = CGPath(rect: bounds, transform: nil)
//        border.cornerRadius = 5
//        border.borderWidth = 1
//        layer?.addSublayer(border)
    }
}
