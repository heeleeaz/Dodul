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

    private var activeIdentifier: NSTouchBarItem.Identifier = Constants.touchBarCollection{didSet{touchBar = nil}}
        
    var touchBarItems: [TouchBarItem] = []{
        didSet{
            if touchBarItems.isEmpty{
                if activeIdentifier != Constants.noItemView {activeIdentifier = Constants.noItemView}
            }else {
                if activeIdentifier != Constants.touchBarCollection{activeIdentifier = Constants.touchBarCollection}
            }
        }
    }

    lazy var collectionView: NSCollectionView = {
        let collectionView = NSCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = NSSize(width: 72, height: 30)
        flowLayout.minimumLineSpacing = 1.0
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(TouchBarCollectionViewItem.self, forItemWithIdentifier: TouchBarCollectionViewItem.reuseIdentifier)
        collectionView.dataSource = self
        return collectionView
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
    
    func touchBarCollectionViewWillAppear(collectionView: NSCollectionView, touchBar: NSTouchBar){
    }
}

extension ReadonlyTouchBarController{
    func touchBarCollectionItemClicked(item: TouchBarItem){
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
    
    public func reloadItems(){
        touchBarItems = (try? TouchBarItemUserDefault.instance.findAll()) ?? []; collectionView.reloadData()
    }
}

extension ReadonlyTouchBarController: NSTouchBarDelegate{
    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let customView = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case Constants.noItemView:
            customView.view = isEnableItemClick ? EmptyTouchBarItemInitView() : EmptyTouchBarItemInfoView()
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
        static let customization = "com.heeleeaz.touchlet.TouchletMenu.customization"
        static let touchBarCollection = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.touchBarCollection")
        static let noItemView = NSTouchBarItem.Identifier("com.heeleeaz.touchlet.TouchletMenu.noItemView")
    }
}
