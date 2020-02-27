//
//  MainTouchBarProvider.swift
//  Touchlet
//
//  Created by Elias on 20/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension MainWindowController{
    struct Constants {
        static let customizationIdentifier = NSTouchBar.CustomizationIdentifier("\(Global.groupIdPrefix).TouchBarProvider")
        static let scrollBarIdentifier = NSTouchBarItem.Identifier("\(Global.groupIdPrefix).scrollbar")
    }
    
    private var faviconImageProvider: FaviconProvider { return FaviconProvider.instance }
        
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

extension MainWindowController: NSTouchBarDelegate{
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let buttonSize = TouchBarUtil.Constant.touchItemButtonSize
        let spacing = TouchBarUtil.Constant.touchItemSpacing
        
        let scrollView = NSScrollView(frame: CGRect(x: 0, y: 0, width: 600, height: 30))
        documentView.distribution = .fillEqually
        documentView.alignment = .centerX
        documentView.orientation = .horizontal
        documentView.spacing = spacing
        scrollView.documentView = documentView
        
        var size = NSSize(width: spacing, height: buttonSize.height)
        for touchBarItem in touchBarItems{
            if addButton(touchBarItem: touchBarItem){size.width += buttonSize.width + spacing}
        }

        documentView.frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)

        let customView = NSCustomTouchBarItem(identifier: identifier)
        customView.view = scrollView
        
        return customView
    }
}

extension MainWindowController{
    private var scrollViewInTouchBar: NSScrollView?{
        return (touchBar?.item(forIdentifier: Constants.scrollBarIdentifier) as? NSCustomTouchBarItem)?.view as? NSScrollView
    }
    
    private func addSubview(_ child: NSView, position: Int, adjustSize: Bool){
        if position > -1 && position < documentView.arrangedSubviews.count{
            documentView.insertArrangedSubview(child, at: position)
        }else{
            documentView.addArrangedSubview(child)
        }
        
        if adjustSize{resizeDocumentView(adjustOperation: "+")}
    }
    
    private func removeSubview(_ child: NSView, adjustSize: Bool){
        if child.superview == nil {return}
    
        child.removeFromSuperview()
        if adjustSize{resizeDocumentView(adjustOperation: "-")}
    }
    
    @discardableResult
    private func addButton(touchBarItem: TouchBarItem, position: Int = -1) -> Bool{
        let adjustSize = placeDemoView.superview == nil
        removeSubview(placeDemoView, adjustSize: false)
        
        guard let image = touchBarItem.iconImage else {return false}
        
        let button = createImageButton(image: image, identifier: touchBarItem.identifier)
        addSubview(button, position: position, adjustSize: adjustSize)
        
        appendVolatileList(touchBarItem) // add the item to volatile item list
        
        return true
    }
       
    private func addSkeleta(_ touchBarItem: TouchBarItem, position: Int = -1, browseOnly: Bool){
        if volatileItemContains(touchBarItem){
            guard let result = findTouchBarButton(touchBarItem.identifier) else {return}
            
            if(browseOnly){
                result.1.state = .browse
                updateButtonPosition(current: result.0, new: position)
                normalizeNeighbourState(position: position)
                animatedButtonBorderSet.insert(result.0)
            }else{
                result.1.state = .normal
            }
                
        }else{
            if browseOnly{
                placeDemoView.state = .browse
                placeDemoView.imageView.image = touchBarItem.iconImage
                addSubview(placeDemoView, position: position, adjustSize: placeDemoView.superview == nil)
            }else{
                addButton(touchBarItem: touchBarItem, position: position)
            }
        }
    }
    
    private func updateButtonPosition(current: Int, new: Int){
        if (new < 0 || new >= documentView.arrangedSubviews.count) {return}
        documentView.insertArrangedSubview(documentView.arrangedSubviews[current], at: new)
    }
    
    private func normalizeNeighbourState(position: Int){
        if position < 0 || position >= documentView.subviews.count {return}
        
        for element in animatedButtonBorderSet{
            if element != position {
                (documentView.subviews[element] as? TouchBarItemButton)?.state = .normal
                animatedButtonBorderSet.remove(element)
            }
        }
    }
    
    private func normalizeNeighbourStateWithSelf(){
        for element in animatedButtonBorderSet{
            (documentView.subviews[element] as? TouchBarItemButton)?.state = .normal
            animatedButtonBorderSet.remove(element)
        }
    }
    
    private func createImageButton(image: NSImage, identifier: String) -> NSView{
        let newImage = image.resize(destSize: CGSize(width: 24, height: 24))
        let button =  TouchBarItemButton(image: newImage)
        button.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier)
        return button
    }
    
    private func resizeDocumentView(adjustOperation: Character){
        let buttonSize = TouchBarUtil.Constant.touchItemButtonSize
        let adjustmentValue = TouchBarUtil.Constant.touchItemSpacing + buttonSize.width
        let newWidth = documentView.frame.width + (adjustOperation == "+" ? (adjustmentValue) : -(adjustmentValue))
        documentView.frame = NSRect(x: 0, y: 0, width: newWidth, height: documentView.frame.height)
    }
    
    private func buttonRectInScrollbar(_ touchBarItem: TouchBarItem) -> CGRect?{
        guard let frame = (scrollViewInTouchBar?.documentView?.subviews.first{
            $0.identifier?.rawValue == touchBarItem.identifier})?.frame else {return nil}
        
        let newX = frame.origin.x + TouchBarUtil.Constant.touchBarRect.origin.x
        return CGRect(origin: CGPoint(x: newX, y: frame.origin.y), size: frame.size)
    }
    
    private func findItemPositionWithinPoint(_ point: NSPoint) -> Int{
        if TouchBarUtil.Constant.touchBarRect.contains(point){
            let normalizedX = point.x - TouchBarUtil.Constant.touchBarRect.origin.x
            let buttonSize = TouchBarUtil.Constant.touchItemButtonSize
            let spacing = TouchBarUtil.Constant.touchItemSpacing
            return Int(normalizedX / (buttonSize.width + (spacing / 2)))
        }
        return point.x < TouchBarUtil.Constant.touchBarRect.origin.x ? 0 : documentView.arrangedSubviews.count
    }
    
    private func findTouchBarButton(_ identifier: String) -> (Int, TouchBarItemButton)?{
        if let index =  (documentView.arrangedSubviews.firstIndex{$0.identifier?.rawValue == identifier}){
            return (index, documentView.arrangedSubviews[index] as! TouchBarItemButton)
        }else {
            return nil
        }
    }
}

extension MainWindowController: PointerLocationObserverDelegate{    
    func pointerLocationObserver(observer: PointerLocationObserver, pointerLocation: NSPoint, inDropRect: Bool) {
        if inDropRect {
            NSCursorHelper.instance.hide()
        }else{
            NSCursorHelper.instance.show();
            normalizeNeighbourStateWithSelf()
            return
        }
                
        let jumpInPos = findItemPositionWithinPoint(pointerLocation)
        guard let touchBarItem = findInVolatileItem(jumpInPos) else {return}
        
        addSkeleta(touchBarItem, position: jumpInPos, browseOnly: true)
    }
    
    func pointerLocationObserver(observer: PointerLocationObserver, startCondition: PointerLocationObserver.StartCondition, pointerLocation: NSPoint, inDropRect: Bool, object: Any?, isTerminated: Bool) {
        if inDropRect && !isTerminated{NSCursorHelper.instance.hide()}
        else {NSCursorHelper.instance.show()}

        guard let touchBarItem = asTouchBarItem(object: object) else {return}
            
        if !inDropRect{removeSubview(placeDemoView, adjustSize: true); return}
    
        let jumpInPos = findItemPositionWithinPoint(pointerLocation)
        addSkeleta(touchBarItem, position: jumpInPos, browseOnly: !isTerminated)
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
