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
    
    private var bookmarkLinks: [CellItem] = []{
        didSet{
            insertReloadingLastItem(startIndex: oldValue.count-1, endIndex: bookmarkLinks.endIndex)
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
    }
    
    override func viewWillAppearSingleInvocked() {
        bookmarkLinks.append(contentsOf: BookmarkRepository.instance.bookmarks)
        bookmarkLinks.append(HomeOptionCollectionItem())
        
        //setup default bookmark from webserver
        if !AppPrefs.shared.hasSetupDefaultBookmark{
            BookmarkWebService.shared.defaultBookmarks { (links, error) in
                DispatchQueue.main.async {
                    if let links = links{
                        self.bookmarkLinks.insert(contentsOf: links, at: self.bookmarkLinks.endIndex-1)
                        
                        //save to disk
                        links.forEach{BookmarkRepository.instance.update(link: $0)}
                        AppPrefs.shared.hasSetupDefaultBookmark = true
                    }
                }
            }
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
        guard let link = bookmarkLinks[index] as? Link else{return nil}
        return TouchBarItem(identifier: link.url, type: .Web)
    }
    
    override var height: CGFloat?{ return (collectionView.contentSize?.height ?? 0) + 60 }
}

extension BookmarkViewController: NSCollectionViewDataSource{
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cellItem = bookmarkLinks[indexPath.item]
        
        if let link = cellItem as? Link{
            let view = collectionView.makeItem(withIdentifier: LinkCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? LinkCollectionViewItem else {
                return view
            }
            
            collectionViewItem.link = link
            collectionViewItem.moreClicked = {
                self.showAddBookmarkController(link, anchor: collectionViewItem.view)
            }
            return collectionViewItem
        }else{
            let view = collectionView.makeItem(withIdentifier: ButtonCollectionViewItem.reuseIdentifier, for: indexPath)
            guard let collectionViewItem = view as? ButtonCollectionViewItem else {return view}
            collectionViewItem.showAction(action: .plusIcon, {
                self.showAddBookmarkController(nil, anchor: collectionViewItem.button)
            })

            return view
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {bookmarkLinks.count}
    
    override func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
        let isLoaded = (collectionView.item(at: indexes.first!) as! LinkCollectionViewItem).isImageLoaded
        if !isLoaded{
            view.undermostWindowView?.makeToast("Drag is only possible when icon is completely downloaded", style: DefaultStyle(position: .bottom))
        }
        
        return isLoaded
    }
}

extension BookmarkViewController: AddLinkViewControllerDelegate{
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, delete link: Link) {
        self.dismiss(controller)
        
        if let index = (bookmarkLinks.firstIndex{($0 as? Link) == link}){
            bookmarkLinks.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, save link: Link) {
        self.dismiss(controller)

        bookmarkLinks.insert(link, at: bookmarkLinks.endIndex-1)
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, update link: Link) {
        self.dismiss(controller)

        if let index = (bookmarkLinks.firstIndex{($0 as? Link) == link}){
            bookmarkLinks.replaceSubrange(index...index, with: [link])
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func addLinkViewController(_ controller: AddLinkViewController, bookmarkRepository: BookmarkRepository, dismiss byUser: Bool) {
        self.dismiss(controller)
    }
}
