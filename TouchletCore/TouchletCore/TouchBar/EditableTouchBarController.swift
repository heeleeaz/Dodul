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
    
    private lazy var mouseDetectionPoint = NSRect(x: 0, y: 0, width: view.frame.width, height: 3)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        isEnableItemClick = false
        CollectionItemDragObserver.instance.delegate = self
    }
    
    private func collectionItemInPoint(_ point: NSPoint) -> Int?{
        let rect = CGRect(x: 178, y: 0, width: collectionView.frame.width, height: 20)
        
        if rect.contains(point){
            let point =  NSPoint(x: point.x - rect.origin.x, y: 0)
            return collectionView.indexPathForItem(at: point)?.item
        }
        
        if point.y <= rect.height{
            return point.x > rect.maxX ? collectionView.numberOfItems(inSection: 0) - 1 : 0
        }else{
            return nil
        }
    }
    
    //TODO: improve highlight performance, ignore looping through all element
    private func highlightItem(at index: Int){
        for element in 0..<collectionView.numberOfItems(inSection: 0){
            (collectionView.item(at: element) as! TouchBarCollectionViewItem).state = .normal
        }
        
        if index != -1{(collectionView.item(at: index) as! TouchBarCollectionViewItem).state = .browse}
    }
    
    override func touchBarCollectionViewWillAppear(collectionView: NSCollectionView, touchBar: NSTouchBar){
        let rect = NSRect(x: 0, y: 0, width: view.frame.width, height: 3)
        view.addTrackingArea(NSTrackingArea(rect: rect, options: [.mouseEnteredAndExited, .enabledDuringMouseDrag, .activeAlways], owner: self, userInfo: nil))
    }
    
    @discardableResult public func commitTouchBarEditing() -> Bool{
        do{
            try TouchBarItemUserDefault.instance.setItems(touchBarItems)
            return true
        }catch{
            return false
        }
    }
}

extension EditableTouchBarController: CollectionItemDragObserverDelegate{
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragging pointerLocation: NSPoint, object: Any?) {
        guard let touchBarItem = object as? TouchBarItem else {return}
        
        if mouseDetectionPoint.contains(pointerLocation){
            guard let index = collectionItemInPoint(pointerLocation) else {return}
            if let existingPosition = touchBarItems.firstIndex(of: touchBarItem){
                //item already in touchbar, and being dragged arround, hence do position swap operation
                touchBarItems.swapAt(existingPosition, index) //swap position
                collectionView.reloadData()
            }else{
                //item does not exists in touch bar, hence, add to touchbar
                touchBarItem.itemState = .adding
                touchBarItems.insert(touchBarItem, at: index)
                collectionView.reloadData()
            }
            highlightItem(at: index) // highlight item either in dragging or insertion state
        }else{
            //if adding operation is in progress(item added to touchbar temporarily)
            //and pointer escape touchbar rect, remove the item from touchbar
            touchBarItems.removeAll{$0 == touchBarItem && $0.itemState == .adding}
            collectionView.reloadData()
            
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
        
//        if let item = collectionItemInPoint(event.locationInWindow){
//            highlightItem(at: item)
//        }
    }
        
    override public func mouseExited(with event: NSEvent) {
        NSCursorHelper.instance.show()
        
        highlightItem(at: -1)
    }
    
    override public func mouseDown(with event: NSEvent) {
        rawDraggingIndex = collectionItemInPoint(event.locationInWindow)
    }

    override public func mouseDragged(with event: NSEvent) {
        guard let existingIndex = rawDraggingIndex else {return}
        
        if let index = collectionItemInPoint(event.locationInWindow){
            touchBarItems.swapAt(existingIndex, index)
            collectionView.reloadData()
            rawDraggingIndex = index
            
            highlightItem(at: existingIndex)
        }else{
            //dragging existing item state & outside of touchbar rect, then change state to hidden
            (collectionView.item(at: existingIndex) as! TouchBarCollectionViewItem).state = .hidden
        }
    }
    
    override public func mouseUp(with event: NSEvent) {
        if !mouseDetectionPoint.contains(event.locationInWindow), let index = rawDraggingIndex{
            touchBarItems.remove(at: index)
            collectionView.reloadData()
        }
        
        rawDraggingIndex = nil
    }
}


extension EditableTouchBarController{
    struct Constants {
        static let collectionIdentifier = NSTouchBarItem.Identifier("\(Global.groupIdPrefix).collectionView")
        static let customizationIdentifier = NSTouchBar.CustomizationIdentifier("\(Global.groupIdPrefix).TouchBarProvider")
        
        static var touchItemButtonSize = NSSize(width: 72, height: 30)
        static var touchItemSpacing = CGFloat(1)
    }
}
