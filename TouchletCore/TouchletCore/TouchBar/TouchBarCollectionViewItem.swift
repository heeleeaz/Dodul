//
//  TouchBarCollectionItem.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarCollectionViewItem: NSCollectionViewItem{
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("TouchBarCollectionViewItem")
    
    var image: NSImage? {didSet{iconImageView.image = image}}
    
    var onTap: (() -> Void)?
    
    private var currentState: State = .normal
    var state: State{
        set{
            switch newValue {
            case .browse:
                if currentState != .browse {browseState()}
            case .hidden:
                if currentState != .hidden {hiddenState()}
            default:
                if currentState != .normal {normalState()}
            }
            currentState = newValue
        }
        
        get{return currentState}
    }
    
    private lazy var iconImageView: NSImageView = NSImageView()
    
    override func loadView() {
        let button = NSButton(title: "", target: self, action: #selector(buttonTapped))
        button.setButtonType(.momentaryPushIn)
        button.bezelStyle = .roundRect
        button.isBordered = false
        button._BackgroundColor = .touchBarButtonColor
        
        self.view = button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()        
    }
    
    private func setupView(){
        view.addSubview(iconImageView)
        iconImageView.imageScaling = .scaleProportionallyDown
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([iconImageView.widthAnchor.constraint(equalToConstant: 24),
                                     iconImageView.heightAnchor.constraint(equalToConstant: 24),
                                     iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    
    @objc func buttonTapped(){
        self.onTap?()
    }
    
    
    private func browseState(){
        view.alphaValue = 1
        view._BackgroundColor = .touchBarButtonHighlightColor
    }
       
    private func normalState(){
        view.alphaValue = 1
        view._BackgroundColor = .touchBarButtonColor
    }
    
    private func hiddenState(){
        view.alphaValue = 0.4
        iconImageView.image = image?.greyscale
    }

    enum State{case normal, browse, hidden}
}

extension NSColor{
    static var touchBarButtonColor = NSColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1)
    static var touchBarButtonHighlightColor = NSColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
}
