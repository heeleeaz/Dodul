//
//  Toast.swift
//  TouchletCore
//
//  Created by Elias on 13/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import Cocoa

public enum Position {
    case center
    case bottom
    case top
}

public protocol Style {
    var fontSize: CGFloat {get}
    var horizontalMargin: CGFloat {get}
    var verticalMargin: CGFloat {get}
    var cornerRadius: CGFloat {get}
    var font: NSFont {get}
    var backgroundColor: NSColor {get}
    var foregroundColor: NSColor {get}
    var fadeInOutDuration: CGFloat {get}
    var fadeInOutDelay: CGFloat {get}
    var position: Position {get set}
}

extension Style {
    public var labelOriginWithMargin: CGPoint {
        return CGPoint(x: horizontalMargin, y: verticalMargin)
    }
    
    public var fontSize: CGFloat {return 14}
    public var font: NSFont {
        return NSFont.systemFont(ofSize: fontSize)
    }
    public var horizontalMargin: CGFloat {return 10}
    public var verticalMargin: CGFloat {return 10}
    public var cornerRadius: CGFloat {return 6}
    public var backgroundColor: NSColor {return .black}
    public var foregroundColor: NSColor {return .white}

    public var fadeInOutDuration: CGFloat {return 1.0}
    public var fadeInOutDelay: CGFloat {return 1.0}
    
    public var position: Position {return .bottom}
}
    
class ToastView: NSView {
    private let message: NSString
    private let labelSize: CGSize
    private let style: Style
    
    init(message: NSString, style: Style) {
        self.message = message
        self.style = style
        self.labelSize = message.size(with: style.fontSize)
        let size = CGSize(width: labelSize.width + style.horizontalMargin * 2,
                          height: labelSize.height + style.verticalMargin * 2)
        let rect = CGRect(origin: .zero, size: size)
        super.init(frame: rect)
        wantsLayer = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if superview != nil {
            configure()
        }
    }
    
    private func configure() {
        frame = superview!.bounds
        let rect = CGRect(origin: style.labelOriginWithMargin, size: labelSize)
        let sizeWithMargin = CGSize(
            width: rect.width + style.horizontalMargin*2,
            height: rect.height + style.verticalMargin*2
        )
        let rectWithMargin = CGRect(
            origin: .zero, // position is manipulated later anyways
            size: sizeWithMargin
        )
        // outside Container
        let container = CALayer()
        container.frame = rectWithMargin
        container.backgroundColor = style.backgroundColor.cgColor
        container.cornerRadius = style.cornerRadius
        
        switch style.position {
        case .bottom:
            container.position = CGRect.botttom(of: superview!)
        case .top:
            container.position = CGRect.top(of: superview!)
        default:
            container.position = CGRect.center(of: superview!)
        }
        
        layer!.addSublayer(container)
        
        // inside TextLayer
        let text = CATextLayer()
        text.frame = rect
        text.position = CGRect.center(of: container)
        text.string = message
        text.font = NSFont.systemFont(ofSize: style.fontSize)
        text.fontSize = style.fontSize
        text.alignmentMode = .center
        text.foregroundColor = style.foregroundColor.cgColor
        text.backgroundColor = style.backgroundColor.cgColor
        text.contentsScale = layer!.contentsScale // For Retina Display
        container.addSublayer(text)
    }
}

extension NSView {
    public func makeToast(_ message: NSString, style: Style) {
        let toast = ToastView(message: message, style: style)
        self.addSubview(toast)
        hideAnimation(view: toast, style: style)
    }
}

fileprivate extension CGRect {
    static func center(of layer: CALayer) -> CGPoint {
        let parentSize = layer.frame.size
        return CGPoint(x: parentSize.width / 2, y: parentSize.height / 2)
    }
    
    static func botttom(of layer: NSView) -> CGPoint {
        let parentSize = layer.frame.size
        return CGPoint(x: parentSize.width / 2, y: 60)
    }
    
    static func top(of layer: NSView) -> CGPoint {
        let parentSize = layer.frame.size
        return CGPoint(x: parentSize.width / 2, y: parentSize.height - 60)
    }
    
    static func center(of parent: NSView) -> CGPoint {
        let parentSize = parent.frame.size
        return CGPoint(x: parentSize.width / 2, y: parentSize.height / 2)
    }
}

fileprivate extension NSString {
    func size(with fontSize: CGFloat) -> CGSize {
        let attr = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: fontSize)]
        return self.size(withAttributes: attr)
    }
}

fileprivate class HideAnimationDelegate: NSObject, CAAnimationDelegate {
    private weak var view: NSView?
    
    fileprivate init(view: NSView) {
        self.view = view
    }
    fileprivate static func delegate(forView view: NSView) -> CAAnimationDelegate {
        return HideAnimationDelegate(view: view)
    }
    fileprivate func animationDidStart(_ anim: CAAnimation) {
        view?.layer?.opacity = 0.0
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        view?.removeFromSuperview()
        view = nil
    }
}

fileprivate class ShowAnimationDelegate: NSObject, CAAnimationDelegate {
    private weak var view: NSView?
    fileprivate init(view: NSView) {
        self.view = view
    }
    fileprivate static func delegate(forView view: NSView) -> CAAnimationDelegate {
        return ShowAnimationDelegate(view: view)
    }
    fileprivate func animationDidStart(_ anim: CAAnimation) {
        view?.layer?.opacity = 1.0
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    }
}

fileprivate func showAnimation(view: NSView, style: Style) {
    let anim = CABasicAnimation(keyPath: "opacity")
    let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    anim.timingFunction = timing
    let currentLayerTime = view.layer!.convertTime(CACurrentMediaTime(), from: nil)
    anim.beginTime = currentLayerTime + CFTimeInterval(style.fadeInOutDelay)
    anim.duration = CFTimeInterval(style.fadeInOutDuration)
    anim.fromValue = 0.0
    anim.toValue = 1.0
    anim.isRemovedOnCompletion = false
    anim.delegate = ShowAnimationDelegate.delegate(forView: view)

    view.layer?.add(anim, forKey: "show animation")
}

fileprivate func hideAnimation(view: NSView, style: Style) {
    let anim = CABasicAnimation(keyPath: "opacity")
    let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    anim.timingFunction = timing
    let currentLayerTime = view.layer!.convertTime(CACurrentMediaTime(), from: nil)
    anim.beginTime = currentLayerTime + CFTimeInterval(style.fadeInOutDelay)
    anim.duration = CFTimeInterval(style.fadeInOutDuration)
    anim.fromValue = 1.0
    anim.toValue = 0.0
    anim.isRemovedOnCompletion = false
    anim.delegate = HideAnimationDelegate.delegate(forView: view)

    view.layer!.add(anim, forKey: "hide animation")
}
