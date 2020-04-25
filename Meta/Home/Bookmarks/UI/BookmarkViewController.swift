//
//  BookmarkTableRowView.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore

class BookmarkViewController: HomeCollectionViewController, StoryboardLoadable{
    static var storyboardName: String?{return "HomeItemViewController"}
            
    private var bookmarkLinks = BookmarkRepository.instance.bookmarks{
        didSet{
            delegate?.homeCollectionViewController(self, itemHeightChanged: height)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 120, height: 110)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = flowLayout

        collectionView.register(LinkCollectionViewItem.self, forItemWithIdentifier: LinkCollectionViewItem.reuseIdentifier)
        collectionView.register(ButtonCollectionViewItem.self, forItemWithIdentifier: ButtonCollectionViewItem.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupDefaultBookmark()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if bookmarkLinks.isEmpty{
            removeTrailItem(collectionView)
            insertItems(collectionView, oldCount: 0, newCount: bookmarkLinks.count)
        }
    }
    
    private func showAddBookmarkController(_ link: Link?, anchor: NSView){
        if let controller = AddLinkViewController.createFromNib(){
            controller.prefillLink = link
            controller.delegate = self
            presentAsTooltop(controller, anchor: anchor)
        }
    }
    
    override func touchBarItem(at index: Int) -> TouchBarItem? {
        return TouchBarItem(identifier: bookmarkLinks[index].url, type: .Web)
    }
    
    override var height: CGFloat?{ return (collectionView.contentSize?.height ?? 0) + 60 }
    
    private func addLink(link: Link){
        bookmarkLinks.append(link)
        removeTrailItem(collectionView)
        insertItems(collectionView, oldCount: bookmarkLinks.count-1, newCount: bookmarkLinks.count)
    }
    
    private func setupDefaultBookmark(){
        if !AppPrefs.shared.hasSetupDefaultBookmark{
            BookmarkWebService.shared.defaultBookmarks { (links, error) in
                if let links = links{
                    links.forEach{ link in
                        DispatchQueue.main.async {self.addLink(link: link)}
                        if !BookmarkRepository.instance.contains(link: link){BookmarkRepository.instance.save(bookmark: link)}
                    }
                    AppPrefs.shared.hasSetupDefaultBookmark = true
                }
            }
        }
    }
}

extension BookmarkViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        if(indexPath.item < bookmarkLinks.count){
            let view = collectionView.makeItem(withIdentifier: LinkCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? LinkCollectionViewItem else {return view}
            let link = bookmarkLinks[indexPath.item]
            
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
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {bookmarkLinks.count + 1}
    
    override func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        let isLoaded = (collectionView.item(at: indexes.first!) as! LinkCollectionViewItem).isImageLoaded
        if !isLoaded{
            view.undermostWindowView?.makeToast("Hold a sec, while icon is downloaded!", style: DefaultStyle(position: .bottom))
        }
        
        return isLoaded
    }
}

extension BookmarkViewController: AddLinkViewControllerDelegate{
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, delete link: Link) {
        self.dismiss(controller)
        
        if  let index = bookmarkLinks.firstIndex(of: link){
            bookmarkLinks.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, save link: Link) {
        self.dismiss(controller)

        addLink(link: link)
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, update link: Link) {
        self.dismiss(controller)

        if let index = bookmarkLinks.firstIndex(of: link){
            bookmarkLinks.replaceSubrange(index...index, with: [link])
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, dismiss byUser: Bool) {
        self.dismiss(controller)
    }
}
