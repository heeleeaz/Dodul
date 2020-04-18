//
//  TouchBarEditorController.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

open class EditableTouchBarController: ReadonlyTouchBarController{
    private var draggingImageComponent: [NSDraggingImageComponent]?
    
    //serves for item removal and insertion accepted point rect
    private lazy var acceptChangesRect = NSRect(x: 0, y: 0, width: view.frame.width, height: 3)
    
    override var emptyCollectionTouchbarItem: NSTouchBarItem{
        EditableEmptyCollectionTouchBarItem(identifier: Constants.emptyCollectionIdentifier)
    }
    
    override var editButtonTouchBarItem: NSTouchBarItem?{nil}
        
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.registerForDraggedTypes([.string, .rtfd])
        (view as? DragDestinationObservableView)?.delegate = self
    }
    
    public var isTouchbarDirty:Bool {!TouchBarItemUserDefault.shared.compare(collectionViewTouchBarItem.items)}
    
    @discardableResult public func commitTouchBarEditing() -> Bool{
        do{
            try TouchBarItemUserDefault.shared.setItems(collectionViewTouchBarItem.items)
            return true
        }catch{
            return false
        }
    }
    
    open override func setupTouchbarCollectionView(identifier: NSTouchBarItem.Identifier) -> CollectionViewTouchBarItem {
        let item = CollectionViewTouchBarItem(identifier: identifier, trackingRect: acceptChangesRect, trackingEventView: view)
        item.delegate = self
        return item
    }
}

extension EditableTouchBarController: DragDestinationObservableViewDelegate{
    public func dragDestinationObservableView(_ view: DragDestinationObservableView, info: NSDraggingInfo, willBeginAt screenPoint: NSPoint) {
        guard let collectionView = info.draggingSource as? NSCollectionView else{
            fatalError("dragging source must be a type of NSCollectionView")
        }
        
        if let stringValue = info.draggingPasteboard.string(forType: .string){
            draggingImageComponent = collectionView.item(at: Int(stringValue)!)?.draggingImageComponents
        }
    }
    
    public func dragDestinationObservableView(_ view: DragDestinationObservableView, info: NSDraggingInfo, updated screenPoint: NSPoint) {
        guard let data = info.draggingPasteboard.data(forType: .rtfd),
            let touchBarItem = NSKeyedUnarchiver.unarchiveObject(with: data) as? TouchBarItem else {return}
        
        if acceptChangesRect.contains(screenPoint){
            NSCursorHelper.instance.hide()

            guard let index = collectionViewTouchBarItem.index(at: screenPoint) else {return}
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
    
    public func dragDestinationObservableView(_ view: DragDestinationObservableView, info: NSDraggingInfo, endedAt screenPoint: NSPoint) {
        guard let data = info.draggingPasteboard.data(forType: .fileContents),
            let touchBarItem = try? NSKeyedUnarchiver.unarchivedObject(ofClass: TouchBarItem.self, from: data) else {return}
        
        //if mouse is released and item is being dragged around touchbar rect, change the state to dropped,
        //so it will not be removed from touchbar item
        if collectionViewTouchBarItem.items.contains(touchBarItem){ touchBarItem.itemState = .dropped}
    }
    
    public func dragDestinationObservableView(_ view: DragDestinationObservableView, info: NSDraggingInfo, updateDraggingImage screenPoint: NSPoint) -> [NSDraggingImageComponent] {
        return acceptChangesRect.contains(info.draggingLocation) ? [] : draggingImageComponent ?? []
    }
}
