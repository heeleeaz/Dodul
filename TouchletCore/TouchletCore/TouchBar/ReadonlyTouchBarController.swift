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

    private var activeIdentifier: NSTouchBarItem.Identifier = Constants.collectionIdentifier{didSet{touchBar = nil}}
    
    lazy var collectionViewTouchBarItem: CollectionViewTouchBarItem = {
        let item = CollectionViewTouchBarItem(identifier: Constants.collectionIdentifier, isClickable: isItemClickable)
        item.delegate = self
        return item
    }()
    var emptyCollectionTouchbarItem: NSTouchBarItem {ReadonlyEmptyCollectionTouchBarItem(identifier: Constants.emptyCollectionIdentifier)}
    var editButtonTouchBarItem: NSTouchBarItem? {EditButtonTouchBarItem(identifier: Constants.editIdentifier)}
    
    override open func makeTouchBar() -> NSTouchBar? {
        let touchBar =  NSTouchBar()
        touchBar.delegate = self
        
        touchBar.customizationIdentifier = Constants.customization
        touchBar.customizationAllowedItemIdentifiers = [activeIdentifier, Constants.editIdentifier]
        touchBar.defaultItemIdentifiers = [activeIdentifier, Constants.editIdentifier]
        
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
        case Constants.emptyCollectionIdentifier:
            return emptyCollectionTouchbarItem
        case Constants.editIdentifier:
            return editButtonTouchBarItem
        case Constants.collectionIdentifier:
            return collectionViewTouchBarItem
        default:
            return nil
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
            if activeIdentifier != Constants.emptyCollectionIdentifier {activeIdentifier = Constants.emptyCollectionIdentifier}
        }else {
            if activeIdentifier != Constants.collectionIdentifier{activeIdentifier = Constants.collectionIdentifier}
        }
    }
}

extension ReadonlyTouchBarController{
    struct Constants {
        static let customization = "com.heeleeaz.touchlet.TouchletMenu.customization"
        static let collectionIdentifier = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.collection")
        static let emptyCollectionIdentifier = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.emptyCollection")
        static let editIdentifier = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.edit")
    }
}
