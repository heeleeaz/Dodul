//
//  ReadonlyTouchBarController.swift
//  Touchlet
//
//  Created by Elias on 03/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

open class ReadonlyTouchBarController: NSViewController, ReadonlyEmptyTouchBarItemDelegate{
    
    var activeIdentifier = Constants.collectionIdentifier{didSet{touchBar = nil}}
    
    var emptyCollectionTouchbarItem: NSTouchBarItem {
        let touchBarItem = ReadonlyEmptyCollectionTouchBarItem(identifier: Constants.emptyCollectionIdentifier)
        touchBarItem.delegate = self
        return touchBarItem
    }
    
    var editButtonTouchBarItem: NSTouchBarItem? {
        let touchBarItem = ReadonlyCollectionEditButtonTouchBarItem(identifier: Constants.editIdentifier)
        touchBarItem.delegate = self
        return touchBarItem
    }
    
    lazy var collectionViewTouchBarItem = setupTouchbarCollectionView(identifier: Constants.collectionIdentifier)
    
    override open func makeTouchBar() -> NSTouchBar? {
        let touchBar =  NSTouchBar()
        touchBar.delegate = self
        
        touchBar.customizationIdentifier = Constants.customization
        touchBar.customizationAllowedItemIdentifiers = [activeIdentifier, Constants.editIdentifier]
        touchBar.defaultItemIdentifiers = [activeIdentifier, Constants.editIdentifier]
        
        return touchBar
    }
    
    open func setupTouchbarCollectionView(identifier: NSTouchBarItem.Identifier) -> CollectionViewTouchBarItem{
        let item = CollectionViewTouchBarItem(identifier: identifier)
        item.delegate = self
        return item
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        reloadItems()
    }
    
    public func reloadItems(){
        collectionViewTouchBarItem.items = (try? TouchBarItemUserDefault.shared.findAll()) ?? []
        collectionViewTouchBarItem.reloadItems()
    }
    
    open func readonlyEmptyTouchBarItem(addButtonTapped touchBarItem: NSTouchBarItem) {
    }
    
    open func readonlyEmptyTouchBarItem(editButtonTapped touchBarItem: NSTouchBarItem) {
    }
    
    open func didUpdateTouchbarItemList(){
    }
}

extension ReadonlyTouchBarController: CollectionViewTouchBarItemDelegate{
    public func collectionViewTouchBarItem(collectionViewTouchBarItem: CollectionViewTouchBarItem, onTap item: TouchBarItem) {
        Logger.log(text: "launching \(String(describing: item.identifier))")
               
        switch item.type {
        case .Web:
            NSWorkspace.shared.open(URL(fileURLWithPath: item.identifier))
            trackItemClickEvent(label: kCSFWebLink, identifier: item.identifier)
        case .App:
            NSWorkspace.shared.launchApplication(withBundleIdentifier: item.identifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
            trackItemClickEvent(label: kCSFApp, identifier: item.identifier)
        default:
            Logger.log(text: "unrecognised touch item type \(String(describing: item.type))")
            trackItemClickEvent(label: kCSFUnspecified, identifier: item.identifier)
        }
    }
       
    func collectionViewTouchBarItem(didSetItem collectionViewTouchBarItem: CollectionViewTouchBarItem) {
        if collectionViewTouchBarItem.items.isEmpty{
            if activeIdentifier != Constants.emptyCollectionIdentifier {activeIdentifier = Constants.emptyCollectionIdentifier}
        }else {
            if activeIdentifier != Constants.collectionIdentifier{activeIdentifier = Constants.collectionIdentifier}
            didUpdateTouchbarItemList()
        }
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

extension ReadonlyTouchBarController{
    struct Constants {
        static let customization = "com.heeleeaz.touchlet.TouchletMenu.customization"
        static let collectionIdentifier = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.collection")
        static let emptyCollectionIdentifier = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.emptyCollection")
        static let editIdentifier = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.edit")
    }
}
