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
    }
    
    private var touchBarItems: [NSTouchBarItem.Identifier: TouchBarItem]  {
        var dict: [NSTouchBarItem.Identifier: TouchBarItem] = [:]
        try? TouchBarItemUserDefault().findAll().forEach({dict[$0.touchBarIdentifier] = $0})
        return dict
    }
    
    private var faviconImageProvider: FaviconImageProvider { return FaviconImageProvider.instance }
        
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar =  NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = Constants.customizationIdentifier
        touchBar.defaultItemIdentifiers = Array(touchBarItems.keys)        
        return touchBar
    }
    
    @objc private func buttonTapped(button: NSButton, identifier: NSTouchBarItem.Identifier){
    }
    
    private func createImageButton(image: NSImage, identifier: NSTouchBarItem.Identifier) -> NSButton{
        let newImage = image.resize(destSize: CGSize(width: 24, height: 24))
        return NSButton(image: newImage, target: self, action: #selector(buttonTapped(button:identifier:)))
    }
}

extension WindowController: NSTouchBarDelegate{
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard let item = touchBarItems[identifier] else {return nil}
        
        let customTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
        if let image = item.iconImage{
            customTouchBarItem.view = createImageButton(image: image, identifier: identifier)
        }
        return customTouchBarItem
    }
}
