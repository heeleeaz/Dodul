//
//  HomeSupportCollectionViewController.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import TouchletCore

class HomeCollectionViewController: NSViewController{
    @IBOutlet weak var collectionView: NSCollectionView!

    var indexPathsOfItemsBeingDragged: IndexPath?
    
    func touchBarItem(at index: Int) -> TouchBarItem? {return nil}
    
    public weak var delegate: HomeItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.registerForDraggedTypes([.string])
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
    }
    
    var height: CGFloat? {return nil}
}

extension HomeCollectionViewController: NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
        return touchBarItem(at: index)?.identifier as NSPasteboardWriting?
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        indexPathsOfItemsBeingDragged = indexPaths.first
        
        CollectionItemDragObserver.instance.beginDrag(object: touchBarItem(at: (indexPathsOfItemsBeingDragged?.item)!))
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        if let index = indexPathsOfItemsBeingDragged?.item{
            CollectionItemDragObserver.instance.endDrag(object: touchBarItem(at: index))
        }
    }
}

@objc protocol HomeItemViewControllerDelegate {
    func homeItemViewController(collectionItemChanged controller: HomeCollectionViewController)
}
