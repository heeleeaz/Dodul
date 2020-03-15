//
//  TouchBarEditorController.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

open class EditableTouchBarController: ReadonlyTouchBarController{
    private var rawDraggingIndex: Int?
    
    private lazy var mouseDetectionPoint = NSRect(x: 0, y: 0, width: view.frame.width, height: 1)
    
    private lazy var collectionItemMax: Int = {
        if let barWidth = collectionView.superview?.frame.size.width{
            return Int(floor(barWidth / 72))
        }
        else{
            return 9 //default to 9
        }
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        isEnableItemClick = false
        CollectionItemDragObserver.instance.delegate = self
    }
    
    private func collectionItemInPoint(_ point: NSPoint) -> Int?{
        let rect = CGRect(x: 178, y: 0, width: collectionView.frame.width, height: 20)
               
        if rect.contains(point){
            let point =  NSPoint(x: point.x - rect.origin.x, y: 0)
        
            if let index = collectionView.indexPathForItem(at: point)?.item{
                return index
            }else{
                //fallback
                return max(collectionView.numberOfItems(inSection: 0) - 1, 0)
            }
        }
        
        //still under the baseline height
        if point.y <= rect.height{
            if point.x > rect.maxX{
                return max(collectionView.numberOfItems(inSection: 0) - 1, 0)
            }else{
                return 0
            }
        }else{
            return nil
        }
    }
    
    //TODO: improve highlight performance, ignore looping through all element
    private func highlightItem(at index: Int){
        for element in 0..<collectionView.numberOfItems(inSection: 0){
            (collectionView.item(at: element) as? TouchBarCollectionViewItem)?.state = .normal
        }
        
        if index != -1{
            (collectionView.item(at: index) as? TouchBarCollectionViewItem)?.state = .browse
        }
    }
    
    @discardableResult public func commitTouchBarEditing() -> Bool{
        do{
            try TouchBarItemUserDefault.instance.setItems(touchBarItems)
            return true
        }catch{
            return false
        }
    }
    
    override func touchBarCollectionViewWillAppear(collectionView: NSCollectionView, touchBar: NSTouchBar){
        setupTrackingAreas()
    }
}

extension EditableTouchBarController: CollectionItemDragObserverDelegate{
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragging pointerLocation: NSPoint, object: Any?) {
        guard let touchBarItem = object as? TouchBarItem else {return}
                
        if mouseDetectionPoint.contains(pointerLocation){
            guard let index = collectionItemInPoint(pointerLocation) else {return}
            if let existingIndex = touchBarItems.firstIndex(of: touchBarItem){
                //item already in touchbar, and being dragged arround, hence do position swap operation
                swapItem(at: existingIndex, to: index)
            }else{
                //item does not exists in touch bar, hence, add to touchbar
                touchBarItem.itemState = .adding
                insertItem(touchBarItem: touchBarItem, at: index)
            }
            highlightItem(at: index) // highlight item either in dragging or insertion state
        }else{
            //if adding operation is in progress(item added to touchbar temporarily)
            //and pointer escape touchbar rect, remove the item from touchbar
            if let index = touchBarItems.firstIndex(where: {$0 == touchBarItem && $0.itemState == .adding}){
                removeItem(at: [index])
            }
            
            //since we are already outside of touchbar drop detection rect. we can hide all hightlight
            highlightItem(at: -1)
        }
    }
    
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragEnded pointerLocation: NSPoint, object: Any?) {
        guard let touchBarItem = object as? TouchBarItem else {return}
        
        //if mouse is released and item is being dragged around touchbar rect, change the state to dropped,
        //so it will not be removed from touchbar item
        if touchBarItems.contains(touchBarItem){ touchBarItem.itemState = .dropped}
    }
}

extension EditableTouchBarController {
    override public func mouseEntered(with event: NSEvent) {
        NSCursorHelper.instance.hide()
        
        if let item = collectionItemInPoint(event.locationInWindow){highlightItem(at: item)}
    }
        
    override public func mouseExited(with event: NSEvent) {
        NSCursorHelper.instance.show()
        
        highlightItem(at: -1)
    }
    
    open override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        
        if let item = collectionItemInPoint(event.locationInWindow){highlightItem(at: item)}
    }
    
    override public func mouseDown(with event: NSEvent) {
        rawDraggingIndex = collectionItemInPoint(event.locationInWindow)
    }

    override public func mouseDragged(with event: NSEvent) {
        guard let existingIndex = rawDraggingIndex else {return}
        
        if let index = collectionItemInPoint(event.locationInWindow){
            swapItem(at: existingIndex, to: index)
            
            rawDraggingIndex = index
            highlightItem(at: index)
        }else{
            //dragging existing item outside of touchbar rect, then change state to hidden
            if event.locationInWindow.y >= 30{
                (collectionView.item(at: existingIndex) as! TouchBarCollectionViewItem).state = .hidden
            }
        }
        
        if let image = (collectionView.item(at: existingIndex) as? TouchBarCollectionViewItem)?.image,
            let dragImage = DraggingTouchItemDrawing.instance.draw(image){
            NSCursor(image: dragImage, hotSpot: .zero).set()
        }
    }
    
    override public func mouseUp(with event: NSEvent) {
        if !mouseDetectionPoint.contains(event.locationInWindow), let index = rawDraggingIndex{
            removeItem(at: [index])
        }
        
        NSCursor.arrow.set()
        
        rawDraggingIndex = nil
    }
    
    private func setupTrackingAreas(){
        let rect = NSRect(x: 0, y: 0, width: view.frame.width, height: 3)
        view.addTrackingArea(NSTrackingArea(rect: rect, options: [.mouseEnteredAndExited, .enabledDuringMouseDrag, .mouseMoved, .activeAlways], owner: self, userInfo: nil))
    }
}

extension EditableTouchBarController{
    private func swapItem(at: Int, to: Int){
        touchBarItems.swapAt(at, to) //swap position
        (collectionView.animator() as NSCollectionView).moveItem(at: IndexPath(item: at, section: 0), to: IndexPath(item: to, section: 0))
    }
    
    private func insertItem(touchBarItem: TouchBarItem, at index: Int){
        if touchBarItems.count >= collectionItemMax{
            view.makeToast("Sorry, only \(collectionItemMax) items can be added at the moment." as NSString)
            return
        }
        
        touchBarItems.insert(touchBarItem, at: index)
        (collectionView.animator() as NSCollectionView).insertItems(at: [IndexPath(item: index, section: 0)])
    }
    
    private func removeItem(at indexSet: [Int]){
        indexSet.forEach{
            touchBarItems.remove(at: $0)
            (collectionView.animator() as NSCollectionView).deleteItems(at: [IndexPath(item: $0, section: 0)])
        }
    }
}

extension EditableTouchBarController{
    struct Constants {
        static let collectionIdentifier = NSTouchBarItem.Identifier("\(Global.groupIdPrefix).collectionView")
        static let customizationIdentifier = NSTouchBar.CustomizationIdentifier("\(Global.groupIdPrefix).TouchBarProvider")
        
        static let touchItemButtonSize = NSSize(width: 72, height: 30)
        static let touchItemSpacing = CGFloat(1)
    }
}
