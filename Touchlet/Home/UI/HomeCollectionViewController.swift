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
    
    func touchBarItem(at index: Int) -> TouchBarItem? {return nil}
    
    public weak var delegate: HomeItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
    }
    
    var height: CGFloat? {return nil}
}

extension HomeCollectionViewController: NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setString(String(index), forType: .string)
        
        if let touchbarItem = touchBarItem(at: index),
            let data = try? NSKeyedArchiver.archivedData(withRootObject: touchbarItem, requiringSecureCoding: false){
            print(pasteboardItem.setData(data, forType: .rtfd))
        }
        
        
        return pasteboardItem
    }
}

@objc protocol HomeItemViewControllerDelegate {
    func homeItemViewController(collectionItemChanged controller: HomeCollectionViewController)
}
