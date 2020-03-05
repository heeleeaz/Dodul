//
//  ReadonlyTouchBarController.swift
//  Touchlet
//
//  Created by Elias on 03/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

open class ReadonlyTouchBarController: NSViewController{
    var isEnableItemClick = true
    
    var touchBarItems: [TouchBarItem] = (try? TouchBarItemUserDefault.instance.findAll()) ?? []

    lazy var collectionView: NSCollectionView = {
        let collectionView = NSCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = Constants.touchItemButtonSize
        flowLayout.minimumLineSpacing = Constants.touchItemSpacing
        collectionView.collectionViewLayout = flowLayout
        
        return collectionView
    }()
    
    override open func makeTouchBar() -> NSTouchBar? {
        let touchBar =  NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = Constants.customizationIdentifier
        touchBar.defaultItemIdentifiers = [Constants.collectionIdentifier]
        return touchBar
    }
    
    func touchBarCollectionViewWillAppear(collectionView: NSCollectionView, touchBar: NSTouchBar){
    }
    
    func touchBarCollectionItemClicked(item: TouchBarItem){
        switch item.type {
        case .App:
            print("App")
            
        default:
            print("Web Link")
        }
    }
}

extension ReadonlyTouchBarController: NSTouchBarDelegate{
    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        collectionView.register(TouchBarCollectionViewItem.self, forItemWithIdentifier: TouchBarCollectionViewItem.reuseIdentifier)
        collectionView.dataSource = self
        
        let customView = NSCustomTouchBarItem(identifier: identifier)
        customView.view = collectionView
        
        touchBarCollectionViewWillAppear(collectionView: collectionView, touchBar: touchBar)
        return customView
    }
}

extension ReadonlyTouchBarController: NSCollectionViewDataSource{
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return touchBarItems.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let view = collectionView.makeItem(withIdentifier: TouchBarCollectionViewItem.reuseIdentifier, for: indexPath)
        
        guard let collectionViewItem = view as? TouchBarCollectionViewItem else {return view}
        collectionViewItem.image = touchBarItems[indexPath.item].iconImage
        
        collectionViewItem.onTap = {
            if self.isEnableItemClick{
                self.touchBarCollectionItemClicked(item: self.touchBarItems[indexPath.item])
            }
        }

        return collectionViewItem
    }
}

extension ReadonlyTouchBarController{
    struct Constants {
        static let collectionIdentifier = NSTouchBarItem.Identifier("\(Global.groupIdPrefix).collectionView")
        static let customizationIdentifier = NSTouchBar.CustomizationIdentifier("\(Global.groupIdPrefix).TouchBarProvider")
        
        static var touchItemButtonSize = NSSize(width: 72, height: 30)
        static var touchItemSpacing = CGFloat(1)
    }
}
