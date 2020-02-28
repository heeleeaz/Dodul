//
//  HomeCollectionViewControllerSupport.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class HomeSupportCollectionViewController: NSViewController, NSCollectionViewDelegate{
    @IBOutlet weak var collectionView: NSCollectionView!

    var indexPathsOfItemsBeingDragged: IndexPath?
    
    func itemAtPosition(at index: Int) -> String? {return nil}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerForDraggedTypes([.string])
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
    }
}

extension HomeSupportCollectionViewController{
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
        return itemAtPosition(at: index) as NSPasteboardWriting?
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        indexPathsOfItemsBeingDragged = indexPaths.first
        
        NotificationCenter.default.post(name: .dragBegin, object: itemAtPosition(at: (indexPathsOfItemsBeingDragged?.item)!))
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        if let index = indexPathsOfItemsBeingDragged?.item{
            NotificationCenter.default.post(name: .dragEnded, object: itemAtPosition(at: index))
        }
    }
}
