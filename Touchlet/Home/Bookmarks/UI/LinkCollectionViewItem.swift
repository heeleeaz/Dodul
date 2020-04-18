//
//  LinkCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 11/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import TouchletCore
import FavIcon

class LinkCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("LinkCollectionViewItem")
            
    var link: Link!{didSet{if isViewLoaded { updateView() }}}
    
    var moreClicked: (() -> Void)?
    
    private(set) var isImageLoaded: Bool = false
    
    lazy var linkIconimageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyDown
        imageView.image = NSImage(named: "NSBookmarksTemplate")
        
        return imageView
    }()
    
    private lazy var addressTextField: NSTextField = {
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
        view._backgroundColor = Theme.touchBarButtonBackgroundColor
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
        
        
        
        touchRect.addSubview(linkIconimageView)
        linkIconimageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([linkIconimageView.centerYAnchor.constraint(equalTo: touchRect.centerYAnchor),
                                     linkIconimageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     linkIconimageView.widthAnchor.constraint(equalToConstant: 24),
                                     linkIconimageView.heightAnchor.constraint(equalToConstant: 24)])
        
        touchRect.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([moreButton.widthAnchor.constraint(equalToConstant: 13),
                                     moreButton.heightAnchor.constraint(equalToConstant: 20),
                                     moreButton.topAnchor.constraint(equalTo: touchRect.topAnchor, constant: 2),
                                     moreButton.trailingAnchor.constraint(equalTo: touchRect.trailingAnchor, constant: -4)])
        
        view.addSubview(addressTextField)
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([addressTextField.topAnchor.constraint(equalTo: touchRect.bottomAnchor, constant: 5),
                                     addressTextField.leadingAnchor.constraint(equalTo: touchRect.leadingAnchor),
                                     addressTextField.trailingAnchor.constraint(equalTo: touchRect.trailingAnchor),
                                     addressTextField.heightAnchor.constraint(equalToConstant: 25)])
        
        moreButton.isHidden = true
        moreButton.addClickGestureRecognizer{self.moreClicked?()}
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        touchRect.addTrackingArea(NSTrackingArea(rect: touchRect.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
        
        itemAppearanceAnimation(touchRect)
    }
            
    private func updateView(){
        addressTextField.stringValue = link.displayTitle ?? ""
        
        linkIconimageView.image = NSImage(named: "NSBookmarksTemplate")
        isImageLoaded = false
        
    
        if let favicon = FaviconCacheProvider.instance.loadFromCache(path: link.url.absoluteString){
            self.linkIconimageView.image = favicon
            self.isImageLoaded = true
        }else{
            loadFromNetwork(url: link.url, size: CGSize(width: 36, height: 36)){ image, error in
                if let image = image{
                    self.linkIconimageView.image = image
                    self.isImageLoaded = true
                }else{
                    self.isImageLoaded = false
                }
            }
        }
    }
    
    private func loadFromNetwork(url: URL, size: CGSize, completion: @escaping (NSImage?, Error?)->Void){
        do{
            try FavIcon.downloadPreferred(url, width: Int(size.width), height: Int(size.height)){
                switch $0{
                case .success(let image):
                    if let data = image.resize(destSize: size).data {
                        FaviconCacheProvider.instance.insert(data, path: url.absoluteString)
                        completion(image, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                    Logger.log(text: "failed to load favicon from \(url) with preffered size: \(size)")
                }
            }
        }catch let error as NSError{
            completion(nil, error)
            Logger.log(text: "failed to load favicon from \(url) with preffered size: \(size)")
        }
    }
    
    override var draggingImageComponents: [NSDraggingImageComponent]{
        addressTextField.isHidden = true
        moreButton.isHidden = true
        defer {
            addressTextField.isHidden = false
            moreButton.isHidden = false
        }
        return super.draggingImageComponents
    }
    
    override func mouseEntered(with event: NSEvent) {if moreButton.isHidden {moreButton.isHidden = false}}
    
    override func mouseExited(with event: NSEvent) {if !moreButton.isHidden {moreButton.isHidden = true}}
}

