//
//  UIViewExtension.swift
//  project4
//
//  Created by Elias on 13/12/2019.
//  Copyright © 2019 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSView {
    var backgroundColor: NSColor? {
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
    
    var parentViewController: NSViewController? {
        var parentResponder: NSResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder
            if parentResponder is NSViewController {
                return parentResponder as? NSViewController
            }
        }
        return nil
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
