//
//  AddBookmarkCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class LinkCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("LinkCollectionViewItem")
    
    var link: Link!{didSet{if isViewLoaded { updateView() }}}
        
    private func updateView(){
        textField?.stringValue = link.displayTitle ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addClickGestureRecognizer{
//            self.view.parentViewController?.presentAsSheet(self.addLinkViewController)
        }
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
