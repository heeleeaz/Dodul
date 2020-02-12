//
//  TouchItemProvider.swift
//  Touchlet
//
//  Created by Elias on 11/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

public class TouchBarUtil {
    struct Constant {
        static var touchItemButtonSize = NSSize(width: 72, height: 30)
        static var touchItemSpacing = CGFloat(8)
        static var touchBarRect = CGRect(x: 80.0 + CGFloat(120), y: 0, width: 685.0, height: 40.0)
    }
    
    static func findCAShapeLayer(in view: NSView) -> CAShapeLayer?{
        return view.layer?.sublayers?.first{$0 is CAShapeLayer} as? CAShapeLayer
    }
    
    public static var borderedList: Set<Int> = Set()
    
    static func animateBorder(of view: NSView, bounds: CGRect){
        if findCAShapeLayer(in: view) != nil {return}
                
        let borderLayer = CAShapeLayer()
        borderLayer.path = CGPath(roundedRect: bounds, cornerWidth: 5, cornerHeight: 5, transform: nil)
        borderLayer.strokeColor = NSColor.white.cgColor
        borderLayer.lineDashPattern = [4, 2]
        borderLayer.lineWidth = 1
        borderLayer.fillColor = NSColor.clear.cgColor
        
        view.layer?.addSublayer(borderLayer)
        view.wantsLayer = true
        
        let animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = borderLayer.lineDashPattern?.reduce(0) { $0 - $1.intValue } ?? 0
        animation.duration = 1
        animation.repeatCount = .infinity
        borderLayer.add(animation, forKey: "line")
    }
    
    static func removeAnimatedBorder(of view: NSView){
        findCAShapeLayer(in: view)?.removeFromSuperlayer()
    }
}
