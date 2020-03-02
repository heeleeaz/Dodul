//
//  TouchBarController2.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarEditorController: NSViewController{
    private var rawDraggingIndex: Int?
    private var touchBarItems: [TouchBarItem] = (try? TouchBarItemUserDefault.instance.findAll()) ?? []
    
    private lazy var collectionView: NSCollectionView = {
        let collectionView = NSCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = TouchBarUtil.Constant.touchItemButtonSize
        flowLayout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = flowLayout
        
        return collectionView
    }()
    
    private lazy var mouseDetectionPoint = NSRect(x: 0, y: 0, width: view.frame.width, height: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionItemDragObserver.instance.delegate = self
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar =  NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = Constants.customizationIdentifier
        touchBar.defaultItemIdentifiers = [Constants.collectionIdentifier]
        return touchBar
    }
    
    private func collectionItemInPoint(_ point: NSPoint) -> Int?{
        let rect = CGRect(origin: CGPoint(x: 178, y: 0), size: collectionView.frame.size)
        if rect.contains(point){
            let point =  NSPoint(x: point.x - rect.origin.x, y: 0)
            return collectionView.indexPathForItem(at: point)?.item
        }else{
            return point.x < rect.origin.x ? 0 : collectionView.numberOfItems(inSection: 0) - 1
        }
    }
    
    private func highlightItem(at index: Int){
        if index != -1{(collectionView.item(at: index) as! TouchBarCollectionViewItem).state = .browse}
        
        for element in 0..<collectionView.numberOfItems(inSection: 0){
            if element != index {
                (collectionView.item(at: element) as! TouchBarCollectionViewItem).state = .normal
            }
        }
    }
}

extension TouchBarEditorController: CollectionItemDragObserverDelegate{
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragging pointerLocation: NSPoint, object: Any?) {
        guard let touchBarItem = object as? TouchBarItem else {return}
        
        if mouseDetectionPoint.contains(pointerLocation){
            guard let index = collectionItemInPoint(pointerLocation) else {return}
            if let existingPosition = touchBarItems.firstIndex(of: touchBarItem){
                touchBarItems.swapAt(existingPosition, index) //swap position
                collectionView.reloadData()
            }else{
                touchBarItem.itemState = .adding
                touchBarItems.insert(touchBarItem, at: index)
                collectionView.reloadData()
            }
        }else{
            touchBarItems.removeAll{$0 == touchBarItem && $0.itemState == .adding}
            collectionView.reloadData()
        }
    }
    
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragEnded pointerLocation: NSPoint, object: Any?) {
        guard let touchBarItem = object as? TouchBarItem else {return}

        if touchBarItems.contains(touchBarItem){ touchBarItem.itemState = .dropped}
    }
}

extension TouchBarEditorController: NSTouchBarDelegate{
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        collectionView.register(TouchBarCollectionViewItem.self, forItemWithIdentifier: TouchBarCollectionViewItem.reuseIdentifier)
        collectionView.dataSource = self
        
        let customView = NSCustomTouchBarItem(identifier: identifier)
        customView.view = collectionView
        
        touchBarCollectionViewWillAppear(collectionView: collectionView, touchBar: touchBar)
        return customView
    }
}

extension TouchBarEditorController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return touchBarItems.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let view = collectionView.makeItem(withIdentifier: TouchBarCollectionViewItem.reuseIdentifier, for: indexPath)
        
        guard let collectionViewItem = view as? TouchBarCollectionViewItem else {return view}
        collectionViewItem.image = touchBarItems[indexPath.item].iconImage

        return collectionViewItem
    }
}

extension TouchBarEditorController {
     private func touchBarCollectionViewWillAppear(collectionView: NSCollectionView, touchBar: NSTouchBar){
        let rect = NSRect(x: 0, y: 0, width: view.frame.width, height: 3)
        view.addTrackingArea(NSTrackingArea(rect: rect, options: [.mouseEnteredAndExited, .enabledDuringMouseDrag, .activeAlways], owner: self, userInfo: nil))
    }
        
    override func mouseEntered(with event: NSEvent) {
        NSCursorHelper.instance.hide()
    }
        
    override func mouseExited(with event: NSEvent) {
        NSCursorHelper.instance.show()
    }
    
    override func mouseDown(with event: NSEvent) {
        rawDraggingIndex = collectionItemInPoint(event.locationInWindow)
    }

    override func mouseDragged(with event: NSEvent) {
        if let existingIndex = rawDraggingIndex, let index = collectionItemInPoint(event.locationInWindow){
            touchBarItems.swapAt(existingIndex, index)
            collectionView.reloadData()
            rawDraggingIndex = index
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if !mouseDetectionPoint.contains(event.locationInWindow), let index = rawDraggingIndex{
            touchBarItems.remove(at: index)
            collectionView.reloadData()
        }
        
        rawDraggingIndex = nil
    }
}

extension TouchBarEditorController{
    struct Constants {
        static let collectionIdentifier = NSTouchBarItem.Identifier("\(Global.groupIdPrefix).collectionView")
        static let customizationIdentifier = NSTouchBar.CustomizationIdentifier("\(Global.groupIdPrefix).TouchBarProvider")
    }
}
