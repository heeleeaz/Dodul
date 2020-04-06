//
//  TouchBarEditorController.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

open class EditableTouchBarController: ReadonlyTouchBarController{
    override var isItemClickable: Bool{return false}

    private var rawDraggingIndex: Int?
    
    //serves for item removal and insertion accepted point rect
    private lazy var acceptChangesRect = NSRect(x: 0, y: 0, width: view.frame.width, height: 3)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        CollectionItemDragObserver.instance.delegate = self
        
        setupTrackingAreas()
    }
    
    @discardableResult public func commitTouchBarEditing() -> Bool{
        do{
            try TouchBarItemUserDefault.instance.setItems(collectionViewTouchBarItem.items)
            return true
        }catch{
            return false
        }
    }
    
    override var emptyCollectionTouchbarItem: NSTouchBarItem{EditableEmptyCollectionTouchBarItem(identifier: Constants.emptyCollectionIdentifier)}
    
    override var editButtonTouchBarItem: NSTouchBarItem?{nil}
}

extension EditableTouchBarController: CollectionItemDragObserverDelegate{
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragging pointerLocation: NSPoint, object: Any?) {
        guard let touchBarItem = object as? TouchBarItem else {return}
                
        if acceptChangesRect.contains(pointerLocation){
            NSCursorHelper.instance.hide()

            guard let index = collectionViewTouchBarItem.itemInPoint(pointerLocation) else {return}
            if let existingIndex = collectionViewTouchBarItem.items.firstIndex(of: touchBarItem){
                //item already in touchbar, and being dragged arround, hence do position swap operation
                collectionViewTouchBarItem.swapItem(at: existingIndex, to: index)
            }else{
                //item does not exists in touch bar, hence, add to touchbar
                touchBarItem.itemState = .adding
                collectionViewTouchBarItem.insertItem(touchBarItem: touchBarItem, at: index)
            }
            collectionViewTouchBarItem.highlightItem(at: index) // highlight item either in dragging or insertion state
        }else{
            NSCursorHelper.instance.show()
            //if adding operation is in progress(item added to touchbar temporarily)
            //and pointer escape touchbar rect, remove the item from touchbar
            if let index = collectionViewTouchBarItem.items.firstIndex(where: {$0 == touchBarItem && $0.itemState == .adding}){
                collectionViewTouchBarItem.removeItem(at: [index])
            }
            
            //since we are already outside of touchbar drop detection rect. we can hide all hightlight
            collectionViewTouchBarItem.highlightItem(at: -1)
        }
    }
    
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragEnded pointerLocation: NSPoint, object: Any?) {
        guard let touchBarItem = object as? TouchBarItem else {return}
        
        //if mouse is released and item is being dragged around touchbar rect, change the state to dropped,
        //so it will not be removed from touchbar item
        if collectionViewTouchBarItem.items.contains(touchBarItem){ touchBarItem.itemState = .dropped}
    }
}

extension EditableTouchBarController {
    override public func mouseEntered(with event: NSEvent) {
        NSCursorHelper.instance.hide()
        
        if let item = collectionViewTouchBarItem.itemInPoint(event.locationInWindow){
            collectionViewTouchBarItem.highlightItem(at: item)
        }
    }
        
    override public func mouseExited(with event: NSEvent) {
        NSCursorHelper.instance.show(); collectionViewTouchBarItem.highlightItem(at: -1)
    }
    
    open override func mouseMoved(with event: NSEvent) {
        if let item = collectionViewTouchBarItem.itemInPoint(event.locationInWindow){
            collectionViewTouchBarItem.highlightItem(at: item)
        }
    }
    
    override public func mouseDown(with event: NSEvent) {
        rawDraggingIndex = collectionViewTouchBarItem.itemInPoint(event.locationInWindow)
    }

    override public func mouseDragged(with event: NSEvent) {
        guard let existingIndex = rawDraggingIndex else {return}
        
        if let index = collectionViewTouchBarItem.itemInPoint(event.locationInWindow){
            collectionViewTouchBarItem.swapItem(at: existingIndex, to: index)
            
            rawDraggingIndex = index
            collectionViewTouchBarItem.highlightItem(at: index)
        }else{
            //dragging existing item outside of touchbar rect, then change state to hidden
            if event.locationInWindow.y >= 30{collectionViewTouchBarItem.setItemState(at: existingIndex, state: .hidden)}
        }
        
        if let image = collectionViewTouchBarItem.findItem(at: existingIndex)?.image,
            let dragImage = DraggingTouchItemDrawing.instance.draw(image){
            NSCursor(image: dragImage, hotSpot: .zero).set()
        }
    }
    
    override public func mouseUp(with event: NSEvent) {
        if !acceptChangesRect.contains(event.locationInWindow), let index = rawDraggingIndex{
            collectionViewTouchBarItem.removeItem(at: [index])
        }
        
        NSCursor.arrow.set()
        rawDraggingIndex = nil
    }
    
    private func setupTrackingAreas(){
        view.addTrackingArea(NSTrackingArea(rect: NSRect(x: 0, y: 0, width: view.frame.width, height: 1),
                                            options: [.mouseEnteredAndExited, .enabledDuringMouseDrag, .mouseMoved, .activeAlways],
                                            owner: self, userInfo: nil))
    }
}
