//
//  MainTouchBarProvider.swift
//  Touchlet
//
//  Created by Elias on 20/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension WindowController{
    struct Constants {
        static let customizationIdentifier = NSTouchBar.CustomizationIdentifier("\(Global.groupIdPrefix).TouchBarProvider")
        static let scrollBarIdentifier = NSTouchBarItem.Identifier("\(Global.groupIdPrefix).scrollbar")
    }
    
    private var touchBarItems: [TouchBarItem]  {
        (try? TouchBarItemUserDefault.instance.findAll()) ?? []
    }
    
    private var faviconImageProvider: FaviconImageProvider { return FaviconImageProvider.instance }
        
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar =  NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = Constants.customizationIdentifier
        touchBar.defaultItemIdentifiers = [Constants.scrollBarIdentifier]
        return touchBar
    }
    
    @objc private func buttonTapped(button: NSButton, identifier: NSTouchBarItem.Identifier){
    }
}

extension WindowController: NSTouchBarDelegate{
    private var buttonDefSize: NSSize{return NSSize(width: 72, height: 30)}
    private var defSpacing: CGFloat {return CGFloat(8)}
        
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let scrollView = NSScrollView(frame: CGRect(x: 0, y: 0, width: 600, height: 30))
        let documentView = NSView(frame: CGRect.zero)
        
        var size = NSSize(width: defSpacing, height: buttonDefSize.height)
        for touchBarItem in touchBarItems{
            if addButton(touchBarItem: touchBarItem, documentView: documentView){
                size.width += buttonDefSize.width + defSpacing
            }
        }
        
        documentView.frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView.documentView = documentView

        let customView = NSCustomTouchBarItem(identifier: identifier)
        customView.view = scrollView
        
        return customView
    }
    
    private func addButton(touchBarItem: TouchBarItem, documentView: NSView) -> Bool{
        guard let image = touchBarItem.iconImage else {return false}
        
        let button = createImageButton(image: image, identifier: touchBarItem.identifier)
        button.translatesAutoresizingMaskIntoConstraints = false
        documentView.addSubview(button)

        button.widthAnchor.constraint(equalToConstant: buttonDefSize.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonDefSize.height).isActive = true
        button.centerYAnchor.constraint(equalTo: documentView.centerYAnchor).isActive = true
        
        let leading = documentView.subviews.last{$0 != button}?.trailingAnchor ?? documentView.leadingAnchor
        button.leadingAnchor.constraint(equalTo: leading, constant: defSpacing).isActive = true
        return true
    }
    
    private func placeSkeletaButton(position: NSPoint, documentView: NSView) -> Bool{
        let button = SkeletaTouchButtonView(title: "", target: nil, action: nil)
        button.identifier = NSUserInterfaceItemIdentifier(rawValue: "SkeletaButton")
        button.translatesAutoresizingMaskIntoConstraints = false
        documentView.addSubview(button)

        button.widthAnchor.constraint(equalToConstant: buttonDefSize.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonDefSize.height).isActive = true
        button.centerYAnchor.constraint(equalTo: documentView.centerYAnchor).isActive = true
        
        let leading = documentView.subviews.last{$0 != button}?.trailingAnchor ?? documentView.leadingAnchor
        button.leadingAnchor.constraint(equalTo: leading, constant: defSpacing).isActive = true
        return true
    }
    
    private func createImageButton(image: NSImage, identifier: String) -> NSButton{
        let newImage = image.resize(destSize: CGSize(width: 24, height: 24))
        let button =  NSButton(image: newImage, target: self, action: #selector(buttonTapped(button:identifier:)))
        button.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier)
        return button
    }
}

extension WindowController: PointerLocationObserverDelegate{
    private var touchBarRect: CGRect {
        let leadingMargin = CGFloat(120)
        return CGRect(x: 80.0 + leadingMargin, y: 0, width: 685.0, height: 40.0)
    }
    
    private var scrollViewInTouchBar: NSScrollView?{
        return (touchBar?.item(forIdentifier: Constants.scrollBarIdentifier) as? NSCustomTouchBarItem)?.view as? NSScrollView
    }
    
    func pointerLocationObserver(pointerLocation: NSPoint, inDropRect: Bool, object: Any?) {
        guard let scrollView = scrollViewInTouchBar, inDropRect else {return}
        
        var touchBarItem: TouchBarItem!
        if let spotlight = object as? SpotlightItem{
            touchBarItem = TouchBarItem(identifier: spotlight.bundleIdentifier, type: .App)
        } else if let link = object as? Link {
            touchBarItem = TouchBarItem(identifier: link.url.absoluteString, type: .Web)
        }
        
        let documentView = scrollView.documentView!
        
        let rect = buttonRectInScrollbar(touchBarItem)
        Logger.log(text: "Pointer: \(pointerLocation.x) IconX In Scroll: \(rect?.origin.x)")
        
        print(findItemPositionWithinPoint(point: pointerLocation, fallbackPosition: 0))
        
        if touchBarItems.contains(touchBarItem){
            
//            if pointerLocation >= rect?.origin && pointerLocation<=rect
        }
        
//        print(findRelativePosition(mousePosition: pointerLocation))
        
//        if placeSkeletaButton(position: pointerLocation, documentView: documentView){
//            let currentFrame = documentView.frame
//            let newWidth = currentFrame.width + buttonDefSize.width + defSpacing
//            documentView.frame = NSRect(x: 0, y: 0, width: newWidth, height: currentFrame.height)
//        }
//
//
//        if pointerLocation.x > 1000{
//            if addButton(touchBarItem: touchBarItem!, documentView: scrollView.documentView!){
//                let currentFrame = documentView.frame
//                let newWidth = currentFrame.width + buttonDefSize.width + defSpacing
//                documentView.frame = NSRect(x: 0, y: 0, width: newWidth, height: currentFrame.height)
//            }
//        }
//
//
        
    }
    
    func buttonRectInScrollbar(_ touchBarItem: TouchBarItem) -> CGRect?{
        guard let frame = (scrollViewInTouchBar?.documentView?.subviews.first{
            $0.identifier?.rawValue == touchBarItem.identifier})?.frame else {return nil}
        
        let newX = frame.origin.x + touchBarRect.origin.x
        return CGRect(origin: CGPoint(x: newX, y: frame.origin.y), size: frame.size)
    }
    
    private func findItemPositionWithinPoint(point: NSPoint, fallbackPosition: Int) -> Int{
        if touchBarRect.contains(point){
            let normalizedX = point.x - touchBarRect.origin.x
            return Int(normalizedX / (buttonDefSize.width + (defSpacing / 2)))
        }
        return fallbackPosition
    }
}

