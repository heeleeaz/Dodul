//
//  BookmarkTableRowView.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class BookmarkViewController: NSViewController{
    @objc weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    private var bookmarkUserDafault = BookmarkUserDefaults()
    private var links: [Link] = []{ didSet{ collectionView.reloadData() } }
    
    
    override func viewDidLoad() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120, height: 110)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = flowLayout

        collectionView.register(LinkCollectionViewItem.self, forItemWithIdentifier: LinkCollectionViewItem.reuseIdentifier)
        collectionView.register(ButtonCollectionViewItem.self, forItemWithIdentifier: ButtonCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear() {reloadItem()}
    
    private func reloadItem(){
        links = (try? bookmarkUserDafault.findAll()) ?? []
        compactSize(ofView: view.superview!, collectionView, append: 60)
        DispatchQueue.main.async {self.scrollView.fitContent()}
    }
    
    private func showAddBookmarkController(_ link: Link?, anchor: NSView){
        let addLinkController = AddLinkViewController.createFromNib()
        addLinkController?.prefillLink = link
        addLinkController!.delegate = self
        self.presentAsTooltop(addLinkController!, anchor: anchor)
    }
}

extension BookmarkViewController: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        if(indexPath.item < links.count){
            let view = collectionView.makeItem(
                withIdentifier: LinkCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? LinkCollectionViewItem else {return view}
            let link = links[indexPath.item]
            
            collectionViewItem.link = link
            collectionViewItem.moreClicked = {
                self.showAddBookmarkController(link, anchor: collectionViewItem.view)
            }
            
            return collectionViewItem
        }else{
            let view = collectionView.makeItem(
                withIdentifier: ButtonCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? ButtonCollectionViewItem else {return view}
            collectionViewItem.showAction(action: .plusIcon, {
                self.showAddBookmarkController(nil, anchor: collectionViewItem.button)
            })

            return view
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count + (links.count <= 30 ? 1 : 0)
    }
}

extension BookmarkViewController: AddLinkViewControllerDelegate{
    func addLinkViewController(_ controller: AddLinkViewController, deleteLink link: Link?) {
        if let link = link{try? bookmarkUserDafault.removeBookmark(link)}
        reloadItem(); self.dismiss(controller)
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, saveLink link: Link) {
        try? bookmarkUserDafault.addBookmark(link); reloadItem()
        self.dismiss(controller)
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, dismiss byUser: Bool) {
        self.dismiss(controller)
    }
}
