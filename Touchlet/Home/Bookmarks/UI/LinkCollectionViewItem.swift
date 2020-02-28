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
    
    private let cache = Cache<String, Data>()
    
    var link: Link!{didSet{if isViewLoaded { updateView() }}}
    
    var moreClicked: (() -> Void)?
            
    private func updateView(){
        textField?.stringValue = link.displayTitle ?? ""
        
        imageView?.image = NSImage(named: "NSBookmarksTemplate")
        FaviconProvider.instance.load(url: link.url){ (image, error) in
            if let image = image {self.imageView?.image = image}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view as! LinkCollectionView).moreButton.addClickGestureRecognizer{self.moreClicked?()}
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent]{
        return collectionItemDraggingImageComponent(collectionItemView: self.view, iconImage: self.imageView?.image)
    }
}

class LinkCollectionView: NSView{
    @IBOutlet weak var moreButton: NSButton!
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        if moreButton.isHidden {moreButton.isHidden = false}
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        if !moreButton.isHidden {moreButton.isHidden = true}
    }
    
    override func viewWillMove(toWindow newWindow: NSWindow?) {
        moreButton.isHidden = true
        addTrackingArea(NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
    }
}
