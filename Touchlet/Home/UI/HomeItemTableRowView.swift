//
//  HomeItemTableViewCell.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class HomeItemTableRowView: NSTableRowView, NibLoadable{
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("HomeItemTableRowView")

    @IBOutlet weak var collectionView: NSCollectionView!
    
    var corePackageItems: [CorePackageItem] = []{ didSet{ collectionView.reloadData() } }
        
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
        
        collectionView.register(CoreCollectionViewItem.self, forItemWithIdentifier: CoreCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension HomeItemTableRowView: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let reuseIdentifer = CoreCollectionViewItem.reuseIdentifier
        let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
        guard let collectionViewItem = view as? CoreCollectionViewItem else {return view}
        
        let item = corePackageItems[indexPath.item]
        collectionViewItem.label = item.title
        

        switch item.type {
        case .App:
            collectionViewItem.icon = SpotlightRepository.findAppIcon(bundleIdentifier: item.id)
        default:
            print("Set Image for non app \(item.type)")
        }
         
        return collectionViewItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return corePackageItems.count
    }
}
