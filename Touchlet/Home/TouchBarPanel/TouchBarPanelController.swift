//
//  TouchBarPanelController.swift
//  Touchlet
//
//  Created by Elias on 22/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarPanelController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!
        
    private lazy var touchBarItems: [TouchBarItem] = {
        return (try? TouchBarItemUserDefault.instance.findAll()) ?? []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 72, height: 30)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(TouchBarCollectionViewItem.self, forItemWithIdentifier: TouchBarCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerForDragAndDrop()
    }
    
    func registerForDragAndDrop() {
        collectionView.registerForDraggedTypes([.URL])
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: false)
    }
}

extension TouchBarPanelController : NSCollectionViewDelegate, NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return touchBarItems.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let reuseIdentifer = TouchBarCollectionViewItem.reuseIdentifier
        let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
        guard let collectionViewItem = view as? TouchBarCollectionViewItem else {return view}
                   
        collectionViewItem.touchBarItem = touchBarItems[indexPath.item]
        return collectionViewItem
    }
}
