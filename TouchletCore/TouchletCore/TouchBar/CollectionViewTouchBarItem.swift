//
//  CollectionViewTouchBarItem.swift
//  TouchletCore
//
//  Created by Elias on 18/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

class CollectionViewTouchBarItem: NSCustomTouchBarItem{
    var isItemClickable = true

    var items: [TouchBarItem] = []{didSet{delegate?.collectionViewTouchBarItem(didSetItem: self)}}
    
    weak var delegate: CollectionViewTouchBarItemDelegate?
    
    lazy var collectionView = NSCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    init(identifier: NSTouchBarItem.Identifier, isClickable: Bool) {
        super.init(identifier: identifier)
        
        self.isItemClickable = isClickable
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = NSSize(width: 72, height: 30)
        flowLayout.minimumLineSpacing = 1.0
        collectionView.collectionViewLayout = flowLayout
               
        collectionView.register(TouchBarCollectionViewItem.self, forItemWithIdentifier: TouchBarCollectionViewItem.reuseIdentifier)
        collectionView.dataSource = self
    
        let scrollView = NSScrollView()
        scrollView.documentView = collectionView
        view = scrollView
    }
    
    func reloadItems(){collectionView.reloadData()}
    
    func swapItem(at: Int, to: Int){
        items.swapAt(at, to) //swap position
        (collectionView.animator() as NSCollectionView).moveItem(at: IndexPath(item: at, section: 0), to: IndexPath(item: to, section: 0))
    }
       
    func insertItem(touchBarItem: TouchBarItem, at index: Int){
        let maxItem = maxAllowedItem()
        if items.count >= maxItem{
            view.makeToast("Sorry, only \(maxItem) items can be added at the moment." as NSString)
            return
        }
           
        items.insert(touchBarItem, at: index)
        (collectionView.animator() as NSCollectionView).insertItems(at: [IndexPath(item: index, section: 0)])
    }
       
    func removeItem(at indexSet: [Int]){
        indexSet.forEach{
            items.remove(at: $0)
            (collectionView.animator() as NSCollectionView).deleteItems(at: [IndexPath(item: $0, section: 0)])
        }
    }
       
    func itemInPoint(_ point: NSPoint) -> Int?{
        let touchBarRect = CGRect(x: 178, y: 0, width: collectionView.frame.width, height: 20)
                  
        if touchBarRect.contains(point){
            let normalized =  NSPoint(x: point.x - touchBarRect.origin.x, y: 0)
           
            let itemWidth = (collectionView.collectionViewLayout as! NSCollectionViewFlowLayout).itemSize.width
            return min(Int(floor(normalized.x / itemWidth)), max(collectionView.numberOfItems(inSection: 0) - 1, 0))
        }
           
           //still under the baseline height
        if point.y <= touchBarRect.height{
            if point.x > touchBarRect.maxX{return max(collectionView.numberOfItems(inSection: 0) - 1, 0)}
            else{return 0}
        }else{
            return nil
        }
    }
       
    //TODO: improve highlight performance, ignore looping through all element
    func highlightItem(at index: Int){
        for element in 0..<collectionView.numberOfItems(inSection: 0){setItemState(at: element, state: .normal)}
           
        if index != -1{setItemState(at: index, state: .browse)}
    }
       
    func maxAllowedItem() -> Int{
        guard let width = collectionView.superview?.frame.width else {return 9}
        return Int(floor(width / 72))
    }
       
    func setItemState(at index: Int, state: TouchBarCollectionViewItem.State){findItem(at: index)?.state = state}
       
    func findItem(at index: Int) -> TouchBarCollectionViewItem?{collectionView.item(at: index) as? TouchBarCollectionViewItem}
}

extension CollectionViewTouchBarItem: NSCollectionViewDataSource{
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let view = collectionView.makeItem(withIdentifier: TouchBarCollectionViewItem.reuseIdentifier, for: indexPath)
        
        guard let collectionViewItem = view as? TouchBarCollectionViewItem else {return view}
        collectionViewItem.image = itemImage(items[indexPath.item])
        
        collectionViewItem.onTap = {
            if self.isItemClickable{
                self.delegate?.collectionViewTouchBarItem(collectionViewTouchBarItem: self, onTap: self.items[indexPath.item])
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

protocol CollectionViewTouchBarItemDelegate: class {
    func collectionViewTouchBarItem(collectionViewTouchBarItem: CollectionViewTouchBarItem, onTap item: TouchBarItem)
    
    func collectionViewTouchBarItem(didSetItem collectionViewTouchBarItem: CollectionViewTouchBarItem)
}
