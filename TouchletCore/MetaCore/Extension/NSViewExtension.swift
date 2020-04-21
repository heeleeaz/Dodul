//
//  UIViewExtension.swift
//  project4
//
//  Created by Elias on 13/12/2019.
//  Copyright © 2019 Elias Igbalajobi. All rights reserved.
//

import AppKit

extension NSView{
    //making view acceptFirstResponder by default,
    //this will enable NSViewController receive responder event dispatched to responder chain
    open override var acceptsFirstResponder: Bool{return true}
}

extension NSView {
    @IBInspectable public var _backgroundColor: NSColor? {
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
        get {
            if let color = layer?.backgroundColor { return NSColor(cgColor: color)} else {
                return nil
            }
        }
    }
}

extension NSView {
    public var heightConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { needsLayout = true }
    }
    
    public var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { needsLayout = true }
    }
}

extension NSView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var clickGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the click gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addClickGestureRecognizer(_ action: (() -> Void)?) {
//        self.isUserInteractionEnabled = true
        self.clickGestureRecognizerAction = action
        let clickGestureRecognizer = NSClickGestureRecognizer(target: self, action: #selector(handleClickGesture))
        self.addGestureRecognizer(clickGestureRecognizer)
    }
    
    // Every time the user taps on the UIView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleClickGesture(sender: NSClickGestureRecognizer) {
        if let action = self.clickGestureRecognizerAction {action?()}
    }
}

extension NSView{
    @IBInspectable public  var borderColor: NSColor? {
        set {
            wantsLayer = true
            layer?.borderColor = newValue?.cgColor
        }
        get {
            if let color = layer?.borderColor { return NSColor(cgColor: color)} else {
                return nil
            }
        }
    }
       
    @IBInspectable public  var cornerRadius: CGFloat {
        get{
            return layer?.cornerRadius ?? 0
        }
        set{
            wantsLayer = true
            layer?.cornerRadius = newValue
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat{
        set {
            wantsLayer = true
            layer?.borderWidth = newValue
        }
        get {
            return layer?.borderWidth ?? 0
        }
    }
}

extension NSView{
    fileprivate func leastOrigin(view: NSView, minY: CGFloat) -> CGFloat{
        if view.subviews.count > 0 {
            for v in view.subviews{
                let y = v.frame.origin.y + (v.heightConstaint?.constant ?? 0)
                return leastOrigin(view: v, minY: (minY > y ? y : minY))
            }
            return leastOrigin(view: view, minY: minY)
        }else{
            return CGFloat(view.frame.origin.y + (view.heightConstaint?.constant ?? 0))
        }
    }
    
    public var leastOrigin: CGFloat{ leastOrigin(view: self, minY: CGFloat(Int.max))}
}


extension NSView{
    public func enterFullScreenMode(options: NSApplication.PresentationOptions = []){
        let presOptions: NSApplication.PresentationOptions = ([.hideDock, .hideMenuBar])
        let dictionary = [NSView.FullScreenModeOptionKey.fullScreenModeApplicationPresentationOptions: NSNumber(value: presOptions.union(options).rawValue)]
        self.enterFullScreenMode(NSScreen.main!, withOptions: dictionary)
    }
}

extension NSView{
    public var undermostWindowView: NSView? {NSApp.windows.first?.contentView}
}

extension NSPoint{
    public static func center(a: NSSize, b: NSSize) -> NSPoint{
        return NSPoint(x: a.width/2 - b.width/2, y: a.height/2 - b.height/2)
    }
}
