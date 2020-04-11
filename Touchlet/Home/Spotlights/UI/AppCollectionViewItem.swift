//
//  AppCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import TouchletCore

class AppCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("AppCollectionViewItem")
    
    var spotlight: SpotlightItem!{didSet{if isViewLoaded { updateView()}}}
    
    private lazy var appIconImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyDown
        
        return imageView
    }()
    
    private lazy var appNameTextField: NSTextField = {
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
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        itemAppearanceAnimation(view.subviews[0])
    }
    
    override func loadView() {
        super.view = NSView()
        
        let touchRect = NSView()
        touchRect.cornerRadius = 7
        touchRect._backgroundColor = Theme.touchBarButtonBackgroundColor
        view.addSubview(touchRect)
        touchRect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([touchRect.topAnchor.constraint(equalTo: view.topAnchor),
                                     touchRect.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     touchRect.widthAnchor.constraint(equalToConstant: 90),
                                     touchRect.heightAnchor.constraint(equalToConstant: 40)])
        
        
        
        touchRect.addSubview(appIconImageView)
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([appIconImageView.centerYAnchor.constraint(equalTo: touchRect.centerYAnchor),
                                     appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     appIconImageView.widthAnchor.constraint(equalToConstant: 26),
                                     appIconImageView.heightAnchor.constraint(equalToConstant: 26)])
        
        
        view.addSubview(appNameTextField)
        appNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([appNameTextField.topAnchor.constraint(equalTo: touchRect.bottomAnchor, constant: 5),
                                     appNameTextField.leadingAnchor.constraint(equalTo: touchRect.leadingAnchor),
                                     appNameTextField.trailingAnchor.constraint(equalTo: touchRect.trailingAnchor),
                                     appNameTextField.heightAnchor.constraint(equalToConstant: 16)])
    }
    
    private func updateView(){
        appNameTextField.stringValue = spotlight.displayName ?? ""
        appIconImageView.image = SpotlightRepository.findAppIcon(bundleIdentifier: spotlight.bundleIdentifier) ?? NSImage(named: "NSApplicationIcon")
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent]{
        appNameTextField.isHidden = true
        defer{
            appNameTextField.isHidden = false
        }
        return super.draggingImageComponents
    }
}
