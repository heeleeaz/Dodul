//
//  AddBookmarkCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import FavIcon

class LinkCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("LinkCollectionViewItem")
    
    var link: Link!{didSet{if isViewLoaded { updateView() }}}
        
    private func updateView(){
        textField?.stringValue = link.displayTitle ?? ""
        try? FavIcon.downloadPreferred(link.url, width: 192, height: 192, completion: {
            switch $0{
            case IconDownloadResult.success(let image):
                self.imageView?.image = image
            case IconDownloadResult.failure(let error):
                print(error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class AddLinkCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("AddLinkCollectionViewItem")
    @IBOutlet weak var addLinkButton: NSButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLinkButton.addClickGestureRecognizer{
            
        }
    }
    
}
