//
//  BookmarkTableRowView.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
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
        if let controller = AddLinkViewController.createFromNib(){
            controller.prefillLink = link
            controller.delegate = self
            presentAsTooltop(controller, anchor: anchor)
        }
    }
    
    override func touchBarItem(at index: Int) -> TouchBarItem? {
        return TouchBarItem(identifier: links[index].url.absoluteString, type: .Web)
    }
    
    override var height: CGFloat?{ return (collectionView.contentSize?.height ?? 0) + 60 }
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
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {links.count + 1}
    
    override func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        let isLoaded = (collectionView.item(at: indexes.first!) as! LinkCollectionViewItem).isImageLoaded
        if !isLoaded{
            view.undermostWindowView?.makeToast("Hold a sec, while icon is downloaded!", style: DefaultStyle(position: .bottom))
        }
        
        return isLoaded
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

@objc protocol BookmarkViewControllerDelegate {
    func bookmarkViewController(dataReloaded links: [Link])
}
