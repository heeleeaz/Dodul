//
//  CollectionViewDragDestination.swift
//  TouchletCore
//
//  Created by Elias on 13/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

@IBDesignable
public class DragDestinationObservableView: NSView{
    public weak var delegate: DragDestinationObservableViewDelegate?
    
    override public func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        delegate?.dragDestinationObservableView(self, info: sender, willBeginAt: sender.draggingLocation)
        return super.draggingEntered(sender)
    }
    
    override public func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        sender.enumerateDraggingItems(
            options: .clearNonenumeratedImages, for: self,
            classes: [NSString.self], searchOptions: [:]){ (item, _, _) in
                item.imageComponentsProvider = {
                    return self.delegate?.dragDestinationObservableView(self, info: sender, updateDraggingImage: sender.draggingLocation) ?? []
                }
        }
        
        delegate?.dragDestinationObservableView(self, info: sender, updated: sender.draggingLocation)
        return super.draggingUpdated(sender)
    }
    
    public override func draggingEnded(_ sender: NSDraggingInfo) {
        delegate?.dragDestinationObservableView(self, info: sender, endedAt: sender.draggingLocation)
    }
}

public protocol DragDestinationObservableViewDelegate: class {
    func dragDestinationObservableView(_ view: DragDestinationObservableView, info: NSDraggingInfo, willBeginAt screenPoint: NSPoint)
    func dragDestinationObservableView(_ view: DragDestinationObservableView, info: NSDraggingInfo, updated screenPoint: NSPoint)
    func dragDestinationObservableView(_ view: DragDestinationObservableView, info: NSDraggingInfo, endedAt screenPoint: NSPoint)
    func dragDestinationObservableView(_ view: DragDestinationObservableView, info: NSDraggingInfo, updateDraggingImage screenPoint: NSPoint) -> [NSDraggingImageComponent]
}
