//
//  HomeSupportCollectionViewController.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import AppLib

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
        if !isViewAppeared{viewWillAppearSingleInvocked()}
        
        isViewAppeared = true
    }
    
    func viewWillAppearSingleInvocked(){
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
