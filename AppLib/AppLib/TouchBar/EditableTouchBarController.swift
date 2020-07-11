//
//  TouchBarEditorController.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

open class EditableTouchBarController: ReadonlyTouchBarController{
    public var isTouchbarDirty: Bool {
        !TouchBarItemUserDefault.shared.compare(collectionViewTouchBarItem.items)
    }

    private var draggingImageComponent: [NSDraggingImageComponent]?
    
    
    //serves for item removal and insertion accepted point rect
    private lazy var acceptChangesRect = NSRect(x: 0, y: 0, width: view.frame.width, height: 3)
    
    override var emptyCollectionTouchbarItem: NSTouchBarItem{
        return EditableEmptyCollectionTouchBarItem(identifier: Constants.emptyCollectionIdentifier)
    }
    
    override var editButtonTouchBarItem: NSTouchBarItem?{nil}
        
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.registerForDraggedTypes([.string, .rtfd])
        (view as? DragDestinationObservableView)?.delegate = self
    }
    
    
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


fileprivate class EditableEmptyCollectionTouchBarItem: NSCustomTouchBarItem {
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    private lazy var indicatorImage: NSImageView = {
        let imageView = NSImageView(); imageView.image = NSImage(named: "DragIcon180"); return imageView
    }()
        
    private lazy var floatAnimation: CABasicAnimation = {
        let floatAnimation = CABasicAnimation(keyPath: "position")
        floatAnimation.fromValue = [0, 3]
        floatAnimation.toValue = [0, 0]
        floatAnimation.repeatCount = .greatestFiniteMagnitude
        floatAnimation.duration = 0.3
        floatAnimation.autoreverses = true
        return floatAnimation
    }()
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        self.view = NSView()
        
        view.addSubview(indicatorImage)
        indicatorImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([indicatorImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     indicatorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     indicatorImage.widthAnchor.constraint(equalToConstant: 22),
                                     indicatorImage.heightAnchor.constraint(equalToConstant: 22)])
            
        let text = NSText()
        text.textColor = .white
        text.font = NSFont.systemFont(ofSize: 14)
        text.string = "Drag item here"
        view.addSubview(text)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([text.leadingAnchor.constraint(equalTo: indicatorImage.trailingAnchor, constant: 5),
                                     text.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     text.heightAnchor.constraint(equalToConstant: 16),
                                     text.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)])
            
        indicatorImage.wantsLayer = true
        indicatorImage.layer?.add(floatAnimation, forKey: "positionAnimation")
    }
}
