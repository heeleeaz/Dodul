//
//  BookmarkTableRowView.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

class BookmarkViewController: HomeCollectionViewController, StoryboardLoadable{
    static var storyboardName: String?{return "HomeItemViewController"}
            
    private var bookmarkRepository = BookmarkRepository()
    private var links: [Link] = []{
        didSet{
            collectionView.reloadData()
            delegate?.homeItemViewController(collectionItemChanged: self)
        }
    }
        
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
        links = bookmarkRepository.bookmarks
    }
    
    private func showAddBookmarkController(_ link: Link?, anchor: NSView){
        let addLinkController = AddLinkViewController.createFromNib()
        addLinkController?.prefillLink = link
        addLinkController!.delegate = self
        self.presentAsTooltop(addLinkController!, anchor: anchor)
    }
    
    override func itemAtPosition(at index: Int) -> TouchBarItem? {
        return TouchBarItem(identifier: links[index].url.absoluteString, type: .Web)
    }
}

extension BookmarkViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if(indexPath.item < links.count){
            let view = collectionView.makeItem(withIdentifier: LinkCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? LinkCollectionViewItem else {return view}
            let link = links[indexPath.item]
            
            collectionViewItem.link = link
            collectionViewItem.moreClicked = {self.showAddBookmarkController(link, anchor: collectionViewItem.view)}
            
            return collectionViewItem
        }else{
            let view = collectionView.makeItem(withIdentifier: ButtonCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? ButtonCollectionViewItem else {return view}
            collectionViewItem.showAction(action: .plusIcon, {self.showAddBookmarkController(nil, anchor: collectionViewItem.button)})

            return view
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count + (links.count <= Constant.BOOKMARK_MAX_COLLECTION_COUNT ? 1 : 0)
    }
}

extension BookmarkViewController: AddLinkViewControllerDelegate{
    func addLinkViewController(_ controller: AddLinkViewController, deleteLink link: Link?) {
        self.dismiss(controller)
        
        if let link = link, let index = links.firstIndex(of: link){
            bookmarkRepository.deleteBookmark(at: index); reloadItem()
        }
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, saveLink link: Link) {
        self.dismiss(controller)

        if let index = links.firstIndex(of: link){bookmarkRepository.updateBookmark(at: index, with: link)}
        else{bookmarkRepository.save(bookmark: link)}
        
        reloadItem()
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, dismiss byUser: Bool) {
        self.dismiss(controller)
    }
}

extension BookmarkViewController{
    struct Constant {
        static let BOOKMARK_MAX_COLLECTION_COUNT = 15
    }
}

@objc protocol BookmarkViewControllerDelegate {
    func bookmarkViewController(dataReloaded links: [Link])
}
