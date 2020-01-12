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
    
    private lazy var addLinkViewController: AddLinkViewController = {
        let controller =  AddLinkViewController.createFromNib()!; controller.delegate = self
        return controller
    }()
    
    private var bookmarkUserDafault = BookmarkUserDefaults()
    private var links: [Link] = []{ didSet{ collectionView.reloadData() } }
    
    override func viewDidMoveToWindow() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 109, height: 107)
        flowLayout.sectionInset = NSEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = flowLayout
               
        collectionView.register(LinkCollectionViewItem.self, forItemWithIdentifier: LinkCollectionViewItem.reuseIdentifier)
        collectionView.register(AddLinkCollectionViewItem.self, forItemWithIdentifier: AddLinkCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
               
        reloadItem()
    }
    
    private func reloadItem(){links = (try? bookmarkUserDafault.findAll()) ?? []}
}

extension BookmarkTableRowView: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        if(indexPath.item < links.count){
            let reuseIdentifer = LinkCollectionViewItem.reuseIdentifier
            let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
            guard let collectionViewItem = view as? LinkCollectionViewItem else {return view}
            
            collectionViewItem.link = links[indexPath.item]
            return collectionViewItem
        }else{
            let reuseIdentifer = AddLinkCollectionViewItem.reuseIdentifier
            let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
            guard let collectionViewItem = view as? AddLinkCollectionViewItem else {return view}
            collectionViewItem.addLinkButton.addClickGestureRecognizer{
                collectionViewItem.presentAsSheet(self.addLinkViewController)
            }

            return view
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count + (links.count <= 10 ? 1 : 0)
    }
}

extension BookmarkTableRowView: AddLinkViewControllerDelegate{
    func addLinkViewController(_ controller: AddLinkViewController, deleteLink link: Link?) {
        if let link = link{try? bookmarkUserDafault.removeBookmark(link)}
        reloadItem(); controller.dismiss(self)
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, saveLink link: Link) {
        try? bookmarkUserDafault.addBookmark(link); reloadItem()
        controller.dismiss(self)
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, dismiss byUser: Bool) {
        controller.dismiss(self)
    }
}
