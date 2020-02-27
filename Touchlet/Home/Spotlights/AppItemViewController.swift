//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class AppItemViewController: NSViewController{
    struct Constant {
         static let SPOTLIGHT_PAGING_INITIAL = 10
         static let SPOTLIGHT_PAGING_FORWARD = 15
     }
    
    @objc weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    private var indexPathsOfItemsBeingDragged: IndexPath?
    private let spotlightRepository = SpotlightRepository.instance
    private var spotlightResult: SpotlightResult?
    
    private var spotlightItem: [SpotlightItem] = []{
        didSet{
            collectionView.reloadData()
            compactSize(ofView: view.superview!, collectionView, append: 60)            
            DispatchQueue.main.async {
                self.scrollView.fitContent()
                
                //scroll to top in first query
                if self.spotlightItem.count == Constant.SPOTLIGHT_PAGING_INITIAL{
                    self.scrollView.scrollToBeginingOfDocument()
                }
            }
        }
    }
    
    override func viewDidLoad() {
       setupCollectionView()
        
        spotlightRepository.callback = { result in
            self.spotlightResult = result
            self.spotlightItem = self.spotlightResult?.next(forward: Constant.SPOTLIGHT_PAGING_INITIAL) ?? []
        }
        spotlightRepository.query()
    }
    
    private func setupCollectionView(){
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120, height: 110)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(AppCollectionViewItem.self, forItemWithIdentifier: AppCollectionViewItem.reuseIdentifier)
        collectionView.register(ButtonCollectionViewItem.self, forItemWithIdentifier: ButtonCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerForDraggedTypes([.URL])
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: false)
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
                self.spotlightItem += self.spotlightResult?.next(forward: Constant.SPOTLIGHT_PAGING_FORWARD) ?? []
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
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        indexPathsOfItemsBeingDragged = indexPaths.first
        
        NotificationCenter.default.post(name: .dragBegin, object: spotlightItem[indexPaths.first!.item])
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation) {
        if let index = indexPathsOfItemsBeingDragged?.item{
            NotificationCenter.default.post(name: .dragEnded, object: spotlightItem[index])
        }
    }
}

