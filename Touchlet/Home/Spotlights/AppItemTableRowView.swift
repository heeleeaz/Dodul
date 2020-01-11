//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class AppItemTableRowView: NSTableRowView, NibLoadable{
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("AppItemTableRowView")

    @IBOutlet weak var collectionView: NSCollectionView!
    
    private var spotlightRepository = SpotlightRepository.instance
    
    private var spotlightItem: [SpotlightItem] = []{ didSet{ collectionView.reloadData() } }
        
    override func viewDidMoveToWindow() {
        setupView()
    }
    
    private func setupView(){
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 109, height: 107)
        flowLayout.sectionInset = NSEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(AppCollectionViewItem.self, forItemWithIdentifier: AppCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        spotlightRepository.callback = {self.spotlightItem = $0.sortedItems}
        spotlightRepository.doSpotlightQuery()
    }
}

extension AppItemTableRowView: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let reuseIdentifer = AppCollectionViewItem.reuseIdentifier
        let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
        guard let collectionViewItem = view as? AppCollectionViewItem else {return view}
        
        collectionViewItem.spotlight = spotlightItem[indexPath.item]
        return collectionViewItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return spotlightItem.count
    }
}
