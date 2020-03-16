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
        
    var touchBarItems: [TouchBarItem] = []{
        didSet{
            if touchBarItems.isEmpty{
                touchBar?.defaultItemIdentifiers.insert(Constants.emptyListViewIdentifier, at: 0)
            }else{
                touchBar?.defaultItemIdentifiers.removeAll{$0 == Constants.emptyListViewIdentifier}
            }
        }
    }

    lazy var collectionView: NSCollectionView = {
        let collectionView = NSCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = Constants.touchItemButtonSize
        flowLayout.minimumLineSpacing = Constants.touchItemSpacing
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(TouchBarCollectionViewItem.self, forItemWithIdentifier: TouchBarCollectionViewItem.reuseIdentifier)
        collectionView.dataSource = self
        return collectionView
    }()
    
    override open func makeTouchBar() -> NSTouchBar? {
        let touchBar =  NSTouchBar()
        touchBar.delegate = self
        
        touchBar.customizationIdentifier = Constants.customizationIdentifier
        touchBar.customizationAllowedItemIdentifiers = [Constants.collectionIdentifier, Constants.emptyListViewIdentifier]
        touchBar.defaultItemIdentifiers = [Constants.collectionIdentifier]
        
        return touchBar
    }
    
    func touchBarCollectionItemClicked(item: TouchBarItem){
        Logger.log(text: "Launching \(String(describing: item.identifier))")
        
        switch item.type {
        case .Web:
            NSWorkspace.shared.open(URL(fileURLWithPath: item.identifier))
        case .App:
            NSWorkspace.shared.launchApplication(withBundleIdentifier: item.identifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
        default:
            Logger.log(text: "unrecognised touch item type \(String(describing: item.type))")
        }
    }
    
    func touchBarCollectionViewWillAppear(collectionView: NSCollectionView, touchBar: NSTouchBar){
    }
    
    public func refreshTouchBarItems(){
        self.touchBarItems = (try? TouchBarItemUserDefault.instance.findAll()) ?? []
        collectionView.reloadData()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshTouchBarItems()
    }
}

extension ReadonlyTouchBarController: NSTouchBarDelegate{
    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let customView = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case Constants.emptyListViewIdentifier:
            customView.view = EmptyTouchBarItemInfoView()
        default:
            customView.view = collectionView
            touchBarCollectionViewWillAppear(collectionView: collectionView, touchBar: touchBar)
        }
        
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
        collectionViewItem.image = itemImage(touchBarItems[indexPath.item])
        
        collectionViewItem.onTap = {
            if self.isEnableItemClick{
                self.touchBarCollectionItemClicked(item: self.touchBarItems[indexPath.item])
            }
        }

        return collectionViewItem
    }
    
    private func itemImage(_ touchBarItem: TouchBarItem) -> NSImage?{
        switch touchBarItem.type {
        case .App:
            return SpotlightRepository.findAppIcon(bundleIdentifier: touchBarItem.identifier)
        default:
            return FaviconProvider.instance.loadFromCache(url: URL(string: touchBarItem.identifier)!)
        }
    }
}

extension ReadonlyTouchBarController{
    struct Constants {
        static let customizationIdentifier = NSTouchBar.CustomizationIdentifier("\(Bundle.main.bundleIdentifier!).collectionView")
        static let collectionIdentifier = NSTouchBarItem.Identifier("\(Bundle.main.bundleIdentifier!).collectionView")
        static let emptyListViewIdentifier = NSTouchBarItem.Identifier("\(Bundle.main.bundleIdentifier!).emptyListView")
        
        static var touchItemButtonSize = NSSize(width: 72, height: 30)
        static var touchItemSpacing = CGFloat(1)
    }
}
