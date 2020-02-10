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
    private var defTouchBarButtonSize: NSSize{return NSSize(width: 72, height: 30)}
    private var defSpacing: CGFloat {return CGFloat(8)}
        
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let scrollView = NSScrollView(frame: CGRect(x: 0, y: 0, width: 600, height: 30))
        let documentView = NSStackView(frame: CGRect.zero)
        documentView.distribution = .equalSpacing
        documentView.alignment = .centerX
        documentView.orientation = .horizontal
        documentView.spacing = defSpacing
        
        var size = NSSize(width: defSpacing, height: defTouchBarButtonSize.height)
        for touchBarItem in touchBarItems{
            if addButton(touchBarItem: touchBarItem, documentView: documentView){
                size.width += defTouchBarButtonSize.width + defSpacing
            }
        }
        
        documentView.frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView.documentView = documentView

        let customView = NSCustomTouchBarItem(identifier: identifier)
        customView.view = scrollView
        
        return customView
    }
    
    private func addSubview(_ child: NSView, documentView: NSStackView, position: Int, adjustSize: Bool){
        if position > -1 && position < documentView.arrangedSubviews.count{
            documentView.insertArrangedSubview(child, at: position)
        }else{
            documentView.addArrangedSubview(child)
        }
        
        if adjustSize{
            let newWidth = documentView.frame.width + defTouchBarButtonSize.width + defSpacing
            documentView.frame = NSRect(x: 0, y: 0, width: newWidth, height: documentView.frame.height)
        }
    }
    
    @discardableResult
    private func addButton(touchBarItem: TouchBarItem, documentView: NSStackView, position: Int = -1) -> Bool{
        let adjustSize = skeletaButtonView.superview == nil
        removeSkeletaView(documentView: documentView, adjustSize: false)
        
        guard let image = touchBarItem.iconImage else {return false}
        
        let button = createImageButton(image: image, identifier: touchBarItem.identifier)
        addSubview(button, documentView: documentView, position: position, adjustSize: adjustSize)
        
        return true
    }
       
    private func addSkeletaView(_ touchBarItem: TouchBarItem, documentView: NSStackView, position: Int = -1){
        let adjustSize = skeletaButtonView.superview == nil
        addSubview(skeletaButtonView, documentView: documentView, position: position, adjustSize: adjustSize)
    }
    
    private func removeSkeletaView(documentView: NSStackView, adjustSize: Bool){
        if skeletaButtonView.superview == nil {return}
    
        skeletaButtonView.removeFromSuperview()
        if adjustSize{
            let newWidth = documentView.frame.width - defTouchBarButtonSize.width + defSpacing
            documentView.frame = NSRect(x: 0, y: 0, width: newWidth, height: documentView.frame.height)
        }
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

    func pointerLocationObserver(pointerLocation: NSPoint, inDropRect: Bool, object: Any?, isTerminated: Bool) {
        guard let scrollView = scrollViewInTouchBar,
            let touchBarItem = asTouchBarItem(object: object) else {return}
            
        let documentView = scrollView.documentView as! NSStackView
        
        if !inDropRect{removeSkeletaView(documentView: documentView, adjustSize: true); return}
    
        let jumpInPos = findItemPositionWithinPoint(pointerLocation, documentView: documentView)
        if !isTerminated{
            addSkeletaView(touchBarItem, documentView: documentView, position: jumpInPos)
        }else{
            addButton(touchBarItem: touchBarItem, documentView: documentView, position: jumpInPos)
        }
    }
    
    func buttonRectInScrollbar(_ touchBarItem: TouchBarItem) -> CGRect?{
        guard let frame = (scrollViewInTouchBar?.documentView?.subviews.first{
            $0.identifier?.rawValue == touchBarItem.identifier})?.frame else {return nil}
        
        let newX = frame.origin.x + touchBarRect.origin.x
        return CGRect(origin: CGPoint(x: newX, y: frame.origin.y), size: frame.size)
    }
    
    private func findItemPositionWithinPoint(_ point: NSPoint, documentView: NSStackView) -> Int{
        if touchBarRect.contains(point){
            let normalizedX = point.x - touchBarRect.origin.x
            return Int(normalizedX / (defTouchBarButtonSize.width + (defSpacing / 2)))
        }
        return point.x < touchBarRect.origin.x ? 0 : documentView.arrangedSubviews.count
    }
    
    private func asTouchBarItem(object: Any?) -> TouchBarItem?{
        var touchBarItem: TouchBarItem?
        
        if let spotlight = object as? SpotlightItem{
            touchBarItem = TouchBarItem(identifier: spotlight.bundleIdentifier, type: .App)
        } else if let link = object as? Link {
            touchBarItem = TouchBarItem(identifier: link.url.absoluteString, type: .Web)
        }
        
        return touchBarItem
    }
}

