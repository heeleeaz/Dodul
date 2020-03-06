//
//  AppCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import Core

class AppCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("AppCollectionViewItem")
    
    var spotlight: SpotlightItem!{didSet{if isViewLoaded { updateView()}}}
    
    private lazy var cimageView: NSImageView = {
        let imageView = NSImageView()
        imageView.image = NSImage(named: "NSApplicationIcon")
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
    
    override func loadView() {
        super.view = NSView()
        
        let touchRect = NSView()
        touchRect.cornerRadius = 7
        touchRect._BackgroundColor = NSColor(named: "TouchBarButtonBackgroundColor")
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
                                     cimageView.widthAnchor.constraint(equalToConstant: 26),
                                     cimageView.heightAnchor.constraint(equalToConstant: 26)])
        
        
        view.addSubview(ctextField)
        ctextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ctextField.topAnchor.constraint(equalTo: touchRect.bottomAnchor, constant: 5),
                                     ctextField.leadingAnchor.constraint(equalTo: touchRect.leadingAnchor),
                                     ctextField.trailingAnchor.constraint(equalTo: touchRect.trailingAnchor),
                                     ctextField.heightAnchor.constraint(equalToConstant: 16)])
    }
    
    private func updateView(){
        ctextField.stringValue = spotlight.displayName ?? ""
        cimageView.image = SpotlightRepository.findAppIcon(bundleIdentifier: spotlight.bundleIdentifier)
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent]{
        return collectionItemDraggingImageComponent(collectionItemView: view, iconImage: cimageView.image)
    }
}
