//
//  AddBookmarkCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import Core

class LinkCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("LinkCollectionViewItem")
    
    private let cache = Cache<String, Data>()
    
    var link: Link!{didSet{if isViewLoaded { updateView() }}}
    
    var moreClicked: (() -> Void)?
    
    private lazy var cimageView: NSImageView = {
        let imageView = NSImageView()
        imageView.image = NSImage(named: "NSBookmarksTemplate")
        imageView.imageScaling = .scaleProportionallyDown
        
        return imageView
    }()
    
    private lazy var ctextField: NSTextField = {
        let textField = NSTextField()
        textField.font = NSFont.systemFont(ofSize: 13)
        textField.textColor = NSColor.white
        textField.isEditable = false
        textField.isSelectable = false
        textField.drawsBackground = false
        textField.isBezeled = false
        textField.alignment = .center
        textField.maximumNumberOfLines = 1
        textField.lineBreakMode = .byTruncatingTail
        
        return textField
    }()
    
    private lazy var moreButton: NSButton = {
        let button = NSButton()
        button.image = NSImage(named: "verticalEllipses")
        button.bezelStyle = .texturedSquare
        button.isBordered = false
        button.imageScaling = .scaleProportionallyDown
        return button
    }()
    
    private lazy var touchRect: NSView = {
        let view = NSView()
        view.cornerRadius = 7
        view._BackgroundColor = NSColor(named: "TouchBarButtonBackgroundColor")
        
        return view
    }()
    
    override func loadView() {
        super.view = NSView()
        
        view.addSubview(touchRect)
        touchRect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([touchRect.topAnchor.constraint(equalTo: view.topAnchor),
                                     touchRect.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     touchRect.widthAnchor.constraint(equalToConstant: 90),
                                     touchRect.heightAnchor.constraint(equalToConstant: 40)])
        
        
        
        touchRect.addSubview(cimageView)
        cimageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cimageView.centerYAnchor.constraint(equalTo: touchRect.centerYAnchor),
                                     cimageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     cimageView.widthAnchor.constraint(equalToConstant: 24),
                                     cimageView.heightAnchor.constraint(equalToConstant: 24)])
        
        touchRect.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([moreButton.widthAnchor.constraint(equalToConstant: 13),
                                     moreButton.heightAnchor.constraint(equalToConstant: 20),
                                     moreButton.topAnchor.constraint(equalTo: touchRect.topAnchor, constant: 2),
                                     moreButton.trailingAnchor.constraint(equalTo: touchRect.trailingAnchor, constant: -4)])
        
        view.addSubview(ctextField)
        ctextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ctextField.topAnchor.constraint(equalTo: touchRect.bottomAnchor, constant: 5),
                                     ctextField.leadingAnchor.constraint(equalTo: touchRect.leadingAnchor),
                                     ctextField.trailingAnchor.constraint(equalTo: touchRect.trailingAnchor),
                                     ctextField.heightAnchor.constraint(equalToConstant: 16)])
        
        moreButton.isHidden = true
        moreButton.addClickGestureRecognizer{self.moreClicked?()}
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        touchRect.addTrackingArea(NSTrackingArea(rect: touchRect.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
    }
            
    private func updateView(){
        ctextField.stringValue = link.displayTitle ?? ""
        
        cimageView.image = NSImage(named: "NSBookmarksTemplate")
        FaviconProvider.instance.load(url: link.url){ (image, error) in
            if let image = image {self.cimageView.image = image}
        }
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent]{
        return collectionItemDraggingImageComponent(collectionItemView: self.view, iconImage: self.cimageView.image)
    }
    
    override func mouseEntered(with event: NSEvent) {
        if moreButton.isHidden {moreButton.isHidden = false}
    }
    
    override func mouseExited(with event: NSEvent) {
        if !moreButton.isHidden {moreButton.isHidden = true}
    }
}

