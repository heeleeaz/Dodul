//
//  ReadonlyTouchBarController.swift
//  Touchlet
//
//  Created by Elias on 03/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

open class ReadonlyTouchBarController: NSViewController{
    var isItemClickable = true

    private var activeIdentifier: NSTouchBarItem.Identifier = Constants.touchBarCollection{didSet{touchBar = nil}}
    
    lazy var collectionViewTouchBarItem: CollectionViewTouchBarItem = {
        let item = CollectionViewTouchBarItem(identifier: Constants.touchBarCollection, isClickable: isItemClickable)
        item.delegate = self; return item
    }()
    
    override open func makeTouchBar() -> NSTouchBar? {
        let touchBar =  NSTouchBar()
        touchBar.delegate = self
        
        touchBar.customizationIdentifier = Constants.customization
        touchBar.customizationAllowedItemIdentifiers = [activeIdentifier]
        touchBar.defaultItemIdentifiers = [activeIdentifier]
        
        return touchBar
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        reloadItems()
    }
    
    public func reloadItems(){
        collectionViewTouchBarItem.items = (try? TouchBarItemUserDefault.instance.findAll()) ?? []
        collectionViewTouchBarItem.reloadItems()
    }
}

extension ReadonlyTouchBarController: NSTouchBarDelegate{
    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case Constants.noItemView:
            return isItemClickable ? ReadonlyEmptyCollectionTouchBarItem(identifier: identifier) : EditableEmptyCollectionTouchBarItem(identifier: identifier)
        default:
            return collectionViewTouchBarItem
        }
    }
}

extension ReadonlyTouchBarController: CollectionViewTouchBarItemDelegate{
    func collectionViewTouchBarItem(collectionViewTouchBarItem: CollectionViewTouchBarItem, onTap item: TouchBarItem) {
        Logger.log(text: "launching \(String(describing: item.identifier))")
            
        switch item.type {
        case .Web:
            NSWorkspace.shared.open(URL(fileURLWithPath: item.identifier))
        case .App:
            NSWorkspace.shared.launchApplication(withBundleIdentifier: item.identifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
        default:
            Logger.log(text: "unrecognised touch item type \(String(describing: item.type))")
        }
    }
    
    func collectionViewTouchBarItem(didSetItem collectionViewTouchBarItem: CollectionViewTouchBarItem) {
        if collectionViewTouchBarItem.items.isEmpty{
            if activeIdentifier != Constants.noItemView {activeIdentifier = Constants.noItemView}
        }else {
            if activeIdentifier != Constants.touchBarCollection{activeIdentifier = Constants.touchBarCollection}
        }
    }
}

extension ReadonlyTouchBarController{
    struct Constants {
        static let customization = "com.heeleeaz.touchlet.TouchletMenu.customization"
        static let touchBarCollection = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.touchBarCollection")
        static let noItemView = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.noItemView")
    }
}
