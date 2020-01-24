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
    
    private func createImageButton(image: NSImage, identifier: String) -> NSButton{
        let newImage = image.resize(destSize: CGSize(width: 24, height: 24))
        return NSButton(image: newImage, target: self, action: #selector(buttonTapped(button:identifier:)))
    }
    
    func refreshTouchBar(){
//        touchBar?.defaultItemIdentifiers = Array(touchBarItems.keys)
    }
}

extension WindowController: NSTouchBarDelegate{
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let scrollView = NSScrollView(frame: CGRect(x: 0, y: 0, width: 600, height: 30))
        let documentView = NSView(frame: CGRect.zero)
        
        var size = NSSize(width: 8, height: 30)
        for touchBarItem in touchBarItems{
            guard let image = touchBarItem.iconImage else {continue}
            
            let button = createImageButton(image: image, identifier: touchBarItem.identifier)
            button.translatesAutoresizingMaskIntoConstraints = false
            documentView.addSubview(button)

            button.widthAnchor.constraint(equalToConstant: 72).isActive = true
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
            button.centerYAnchor.constraint(equalTo: documentView.centerYAnchor).isActive = true
            
            let leading = documentView.subviews.last{$0 != button}?.trailingAnchor ?? documentView.leadingAnchor
            button.leadingAnchor.constraint(equalTo: leading, constant: 8).isActive = true
            
            size.width += 8 + button.intrinsicContentSize.width
        }
        
        documentView.frame = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        scrollView.documentView = documentView

        let customView = NSCustomTouchBarItem(identifier: identifier)
        customView.view = scrollView
        
        return customView
    }
}
