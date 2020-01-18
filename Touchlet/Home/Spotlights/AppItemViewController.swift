//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class AppItemViewController: NSViewController{
    @objc weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    private var spotlightResult: SpotlightResult?
    
    private var spotlightItem: [SpotlightItem] = []{
        didSet{
            collectionView.reloadData()
            compactSize(ofView: view.superview!, collectionView, append: 60)
            DispatchQueue.main.async {self.scrollView.fitContent()}
        }
    }
    
    override func viewDidLoad() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 140, height: 110)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(AppCollectionViewItem.self, forItemWithIdentifier: AppCollectionViewItem.reuseIdentifier)
        collectionView.register(ButtonCollectionViewItem.self, forItemWithIdentifier: ButtonCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.hideVerticalScrollView()
        
        registerForDragAndDrop()
    }
    
    func registerForDragAndDrop() {
        collectionView.registerForDraggedTypes([.URL])
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: false)
    }
        
    override func viewDidAppear() {
        super.viewDidAppear()
        
        let spotlightRepository = SpotlightRepository.instance
        spotlightRepository.callback = {
            self.spotlightResult = $0
            self.spotlightItem = self.spotlightResult?.next(forward: 10) ?? []
        }
        spotlightRepository.doSpotlightQuery()
    }
}

extension AppItemViewController: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if(indexPath.item < spotlightItem.count){
            let reuseIdentifer = AppCollectionViewItem.reuseIdentifier
            let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
            guard let collectionViewItem = view as? AppCollectionViewItem else {return view}
            
            collectionViewItem.spotlight = spotlightItem[indexPath.item]
            return collectionViewItem
        }else{
            let reuseIdentifer = ButtonCollectionViewItem.reuseIdentifier
            let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
            guard let collectionViewItem = view as? ButtonCollectionViewItem else {return view}
            collectionViewItem.showAction(action: .seeMore, {
                self.spotlightItem += self.spotlightResult?.next(forward: 15) ?? []
            })
            return collectionViewItem
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotlightItem.count + ((spotlightResult?.hasNext ?? false) ? 1 : 0)
    }
}


extension AppItemViewController{
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        return true
    }
    

    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
        return spotlightItem[index].bundleIdentifier as NSPasteboardWriting?
    }
    
//    func collectionView(_ collectionView: NSCollectionView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
//        return true
//    }
}
