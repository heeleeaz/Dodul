//
//  HomeSupportCollectionViewController.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

class HomeCollectionViewController: NSViewController{
    @IBOutlet weak var collectionView: NSCollectionView!
    var isViewAppeared: Bool = false
    
    func touchBarItem(at index: Int) -> TouchBarItem? {return nil}
    
    public weak var delegate: HomeCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
    }
    
    var height: CGFloat? {return nil}
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if !isViewAppeared{
            viewWillAppearSingleInvocked()
        }
        
        isViewAppeared = true
    }
    
    func viewWillAppearSingleInvocked(){
    }
    
    func insertReloadingLastItem(startIndex: Int, endIndex: Int){
        if startIndex > -1{
            let indexPaths = (startIndex ..< endIndex).map{IndexPath(item: $0, section: 0)}
            if indexPaths.count > 0{
                collectionView.insertItems(at: Set<IndexPath>(indexPaths))
                collectionView.reloadItems(at: [indexPaths.first!])
            }
        }
    }
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
            pasteboardItem.setData(data, forType: .rtfd)
        }
        
        return pasteboardItem
    }
}

protocol HomeCollectionViewControllerDelegate: AnyObject {
    func homeCollectionViewController(_ controller: HomeCollectionViewController, itemHeightChanged height: CGFloat?)
}
