//
//  BookmarkTableRowView.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class BookmarkTableRowView: NSTableRowView, NibLoadable{
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("BookmarkTableRowView")

    @IBOutlet weak var collectionView: NSCollectionView!
    
    private var bookmarkUserDafault = BookmarkUserDefaults()
    private var links: [Link] = []{ didSet{ collectionView.reloadData() } }
    
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
        
        collectionView.register(LinkCollectionViewItem.self, forItemWithIdentifier: LinkCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        links = (try? bookmarkUserDafault.findAll()) ?? []
    }
}

extension BookmarkTableRowView: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let reuseIdentifer = LinkCollectionViewItem.reuseIdentifier
        let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
        guard let collectionViewItem = view as? LinkCollectionViewItem else {return view}
        
        collectionViewItem.link = links[indexPath.item]
        return collectionViewItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }
}

