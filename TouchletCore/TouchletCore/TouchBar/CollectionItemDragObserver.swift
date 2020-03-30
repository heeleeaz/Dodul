//
//  TouchBarPanelNotification.swift
//  Touchlet
//
//  Created by Elias on 23/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class CollectionItemDragObserver{
    private var timeInterval: TimeInterval
    private var timer: Timer?
    
    weak var delegate: CollectionItemDragObserverDelegate?
    
    public static let instance = CollectionItemDragObserver()
            
    private init(timeInterval: TimeInterval = 0.1) {
        self.timeInterval = timeInterval
    }
    
    public func beginDrag(object: Any?){
        timer = Timer(timeInterval: timeInterval, repeats: true, block: {_ in self.dispatchDraggingDelegation(object: object)})
        RunLoop.main.add(timer!, forMode: .default)
    }
    
    public func endDrag(object: Any?){
        timer?.invalidate()
        dispatchDraggingDelegation(object: object)
    }
    
    private func dispatchDragEndedDelegation(object: Any?){
        delegate?.collectionItemDragObserver(observer: self, dragEnded: NSEvent.mouseLocation, object: object)
    }
    
    private func dispatchDraggingDelegation(object: Any?){
        delegate?.collectionItemDragObserver(observer: self, dragging: NSEvent.mouseLocation, object: object)
    }
}

protocol CollectionItemDragObserverDelegate: class{
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragging pointerLocation: NSPoint, object: Any?)
    
    func collectionItemDragObserver(observer: CollectionItemDragObserver, dragEnded pointerLocation: NSPoint, object: Any?)
}
