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
    
    private lazy var addLinkViewController: AddLinkViewController = {
        let controller =  AddLinkViewController.createFromNib()!; controller.delegate = self
        return controller
    }()
    
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
    
    override func viewDidAppear() {
        reloadItem()
    }
    
    private func reloadItem(){
        links = (try? bookmarkUserDafault.findAll()) ?? []
        compactSize(ofView: view.superview!, collectionView, append: 60)
        DispatchQueue.main.async {self.scrollView.fitContent()}
    }
}

extension BookmarkViewController: NSCollectionViewDataSource, NSCollectionViewDelegate{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        if(indexPath.item < links.count){
            let reuseIdentifer = LinkCollectionViewItem.reuseIdentifier
            let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
            guard let collectionViewItem = view as? LinkCollectionViewItem else {return view}
            
            collectionViewItem.link = links[indexPath.item]
            return collectionViewItem
        }else{
            let reuseIdentifer = ButtonCollectionViewItem.reuseIdentifier
            let view = collectionView.makeItem(withIdentifier: reuseIdentifer, for: indexPath)
            guard let collectionViewItem = view as? ButtonCollectionViewItem else {return view}
            
            collectionViewItem.showAction(action: .plusIcon) {
                collectionViewItem.presentAsSheet(self.addLinkViewController)
            }

            return view
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count + (links.count <= 10 ? 1 : 0)
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
