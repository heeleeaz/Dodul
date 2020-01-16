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
    
    private let cache = Cache<String, Data>()
    
    var link: Link!{didSet{if isViewLoaded { updateView() }}}
        
    private func updateView(){
        textField?.stringValue = link.displayTitle ?? ""
        
        FaviconImageProvider.instance.load(url: link.url, completion: {
            if let image = $0{
                self.imageView?.image = image
            }else{
                print($1)
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
