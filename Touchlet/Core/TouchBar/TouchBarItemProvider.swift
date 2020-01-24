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
            guard let image = touchBarItem.iconImage else {continue}
            
            let button = createImageButton(image: image, identifier: touchBarItem.identifier)
            button.translatesAutoresizingMaskIntoConstraints = false
            documentView.addSubview(button)

            button.widthAnchor.constraint(equalToConstant: buttonDefSize.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonDefSize.height).isActive = true
            button.centerYAnchor.constraint(equalTo: documentView.centerYAnchor).isActive = true
            
            let leading = documentView.subviews.last{$0 != button}?.trailingAnchor ?? documentView.leadingAnchor
            button.leadingAnchor.constraint(equalTo: leading, constant: defSpacing).isActive = true
            
            size.width += buttonDefSize.width + defSpacing
        }
        
        documentView.frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView.documentView = documentView

        let customView = NSCustomTouchBarItem(identifier: identifier)
        customView.view = scrollView
        
        return customView
    }
    
    private func createImageButton(image: NSImage, identifier: String) -> NSButton{
        let newImage = image.resize(destSize: CGSize(width: 24, height: 24))
        return NSButton(image: newImage, target: self, action: #selector(buttonTapped(button:identifier:)))
    }
}

extension WindowController: PointerLocationObserverDelegate{
    func pointerLocationObserver(pointerLocation: NSPoint, inDropRect: Bool, object: Any?) {
        guard inDropRect else {return}
        
        print(object)
//        guard let index = self.indexPathsOfItemsBeingDragged else {return}
//        let spotlightItem  = self.spotlightItem[index.item]
//
//        let item = TouchBarItem(identifier: spotlightItem.bundleIdentifier, type: .App)
//        try? TouchBarItemUserDefault.instance.addItem(item)
    }
}

