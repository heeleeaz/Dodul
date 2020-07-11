//
//  CollectionViewTouchBarItem.swift
//  TouchletCore
//
//  Created by Elias on 18/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class CollectionViewTouchBarItem: NSCustomTouchBarItem{
    var isClickable = true
    var items: [TouchBarItem] = []{didSet{delegate?.collectionViewTouchBarItem(didSetItem: self)}}
    
    weak var delegate: CollectionViewTouchBarItemDelegate?
    lazy var collectionView = NSCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        
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
    
    convenience init(identifier: NSTouchBarItem.Identifier, trackingRect: CGRect, trackingEventView: NSView){
        self.init(identifier: identifier)
        
        isClickable = false
        _ = CollectionViewTouchBarItemDraggingSupport(rect: trackingRect, collectionViewTouchBarItem: self, trackingEvent: trackingEventView)
    }
    
    func reloadItems(){collectionView.reloadData()}
    
    func swapItem(at: Int, to: Int){
        items.swapAt(at, to) //swap position
        (collectionView.animator() as NSCollectionView).moveItem(at: IndexPath(item: at, section: 0), to: IndexPath(item: to, section: 0))
    }
       
    func insertItem(touchBarItem: TouchBarItem, at index: Int){
        if items.count >= maxAllowedItem(){
            view.undermostWindowView?.makeToast("Max allowed items reached", style: DefaultStyle(position: .bottom))
            return
        }
           
        items.insert(touchBarItem, at: index)
        (collectionView.animator() as NSCollectionView).insertItems(at: [IndexPath(item: index, section: 0)])
        
        trackItemAdd(item: touchBarItem)
    }
       
    func removeItem(at indexSet: [Int]){
        indexSet.forEach{
            //track item removal
            trackItemAdd(item: items[$0])
            
            items.remove(at: $0)
            (collectionView.animator() as NSCollectionView).deleteItems(at: [IndexPath(item: $0, section: 0)])
        }
    }
           
    func index(at point: NSPoint) -> Int?{
        let collectionViewFrame = CGRect(x: 178, y: 0, width: collectionView.visibleRect.width, height: 1)
            
        let itemWidth = (collectionView.collectionViewLayout as! NSCollectionViewFlowLayout).itemSize.width
        if collectionViewFrame.contains(point){
            return bestIndex(at: point)
        }else if point.y <= collectionViewFrame.height{
            let collectionViewEnclosingScrollView = collectionView.enclosingScrollView!
            var currentScrollXPoint = collectionViewEnclosingScrollView.contentView.bounds.origin.x
            if point.x < collectionViewFrame.origin.x{
                currentScrollXPoint = max(0, currentScrollXPoint - itemWidth)
            }else{
                currentScrollXPoint = currentScrollXPoint + itemWidth
            }
            
            collectionViewEnclosingScrollView.contentView.setBoundsOrigin(NSPoint(x: currentScrollXPoint, y: 0))
            
            return bestIndex(at: point)
        }
        
        return nil
    }
    
    private func bestIndex(at point: NSPoint) -> Int{
        let collectionViewFrame = CGRect(x: 178, y: 0, width: collectionView.visibleRect.width, height: 0)
        let itemWidth = (collectionView.collectionViewLayout as! NSCollectionViewFlowLayout).itemSize.width
        
        let scrollOffset = collectionView.enclosingScrollView!.contentView.bounds.origin.x
        let pointerXInCollectionView = (point.x - collectionViewFrame.origin.x) + scrollOffset
        let bestPointIndex = max(Int(floor(pointerXInCollectionView / itemWidth)), 0)
        
        return min(bestPointIndex, max(collectionView.numberOfItems(inSection: 0) - 1, 0))
    }
       
    //TODO: improve highlight performance, ignore looping through all element
    func highlightItem(at index: Int){
        for element in 0..<collectionView.numberOfItems(inSection: 0){setItemState(at: element, state: .normal)}
           
        if index != -1{setItemState(at: index, state: .browse)}
    }
       
    func maxAllowedItem() -> Int{15}
       
    func setItemState(at index: Int, state: TouchBarCollectionViewItem.State){findItem(at: index)?.state = state}
       
    func findItem(at index: Int) -> TouchBarCollectionViewItem?{collectionView.item(at: index) as? TouchBarCollectionViewItem}
}

extension CollectionViewTouchBarItem{
    func trackItemRemoval(item: TouchBarItem){
        let label = item.type == TouchBarItem.TouchBarItemType.App ? kCSFApp : kCSFWebLink
        trackItemRemoveEvent(label: label, identifier: item.identifier)
    }
    
    func trackItemAdd(item: TouchBarItem){
        let label = item.type == TouchBarItem.TouchBarItemType.App ? kCSFApp : kCSFWebLink
        trackItemAddEvent(label: label, identifier: item.identifier)
    }
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
            if self.isClickable{
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
            return FaviconCacheProvider.shared.loadFromCache(path: touchBarItem.identifier)
        }
    }
}

protocol CollectionViewTouchBarItemDelegate: AnyObject {
    func collectionViewTouchBarItem(collectionViewTouchBarItem: CollectionViewTouchBarItem, onTap item: TouchBarItem)
    
    func collectionViewTouchBarItem(didSetItem collectionViewTouchBarItem: CollectionViewTouchBarItem)
}

fileprivate class CollectionViewTouchBarItemDraggingSupport{
    
    private var registeredDraggingIndex: Int?
       
    private var acceptChangesRect: CGRect
    private var collectionViewTouchBarItem: CollectionViewTouchBarItem
    private var trackingEventView: NSView
       
    init(rect: CGRect, collectionViewTouchBarItem: CollectionViewTouchBarItem, trackingEvent view: NSView){
        self.acceptChangesRect = rect
        self.collectionViewTouchBarItem = collectionViewTouchBarItem
        self.trackingEventView = view
     
        view.addTrackingArea(NSTrackingArea(rect: NSRect(x: 0, y: 0, width: view.frame.width, height: 1),
                                            options: [.mouseEnteredAndExited, .enabledDuringMouseDrag, .mouseMoved, .activeAlways],
                                            owner: nil, userInfo: nil))
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(notification:)),
                                               name: NSWindow.willCloseNotification, object: nil)
        registerForDraggingEvent()
    }
    
    private lazy var eventMonitor: ((NSEvent) -> NSEvent?)? = {event in
        if event.window != self.trackingEventView.window {return event}
                
        switch event.type {
        case .leftMouseDown:
            self.registeredDraggingIndex = self.collectionViewTouchBarItem.index(at: event.locationInWindow)
            
        case .mouseMoved:
            if let item = self.collectionViewTouchBarItem.index(at: event.locationInWindow){
                self.collectionViewTouchBarItem.highlightItem(at: item)
            }
        
        case .leftMouseDragged:
            guard let existingIndex = self.registeredDraggingIndex else {return event}

            if let index = self.collectionViewTouchBarItem.index(at: event.locationInWindow){
                self.collectionViewTouchBarItem.swapItem(at: existingIndex, to: index)
                
                self.registeredDraggingIndex = index
                self.collectionViewTouchBarItem.highlightItem(at: index)
            }else{
                //dragging existing item outside of touchbar rect, then change state to hidden
                if event.locationInWindow.y >= 10{
                    self.collectionViewTouchBarItem.setItemState(at: existingIndex, state: .hidden)
                }
            }
            
            if let image = self.collectionViewTouchBarItem.findItem(at: existingIndex)?.image,
                let dragImage = DraggingTouchItemDrawing.instance.draw(image){
                NSCursor(image: dragImage, hotSpot: .zero).set()
            }
            
        case .leftMouseUp:
            if !self.acceptChangesRect.contains(event.locationInWindow), let index = self.registeredDraggingIndex{
                self.collectionViewTouchBarItem.removeItem(at: [index])
            }
            NSCursor.arrow.set()
            self.registeredDraggingIndex = nil
            
        case .mouseEntered:
            if self.acceptChangesRect.contains(event.locationInWindow){
                NSCursorHelper.instance.hide()
                
                if let item = self.collectionViewTouchBarItem.index(at: event.locationInWindow){
                    self.collectionViewTouchBarItem.highlightItem(at: item)
                }
            }
            
        case .mouseExited:
            NSCursorHelper.instance.show(); self.collectionViewTouchBarItem.highlightItem(at: -1)
            
        default:
            return event
        }
        
        
        return event
    }
    
    @objc private func windowWillClose(notification: NSNotification){
        if ((notification.object as? NSWindow) == trackingEventView.window) && eventMonitor != nil {
            NSEvent.removeMonitor(eventMonitor!)
            eventMonitor = nil
        }
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: nil)
    }
    
    private func registerForDraggingEvent(){
        if eventMonitor != nil{
            NSEvent.addLocalMonitorForEvents(matching: [.mouseEntered, .mouseExited, .mouseMoved, .leftMouseDown, .leftMouseUp, .leftMouseDragged], handler: eventMonitor!)
        }
    }
}
