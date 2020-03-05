//
//  TextCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 16/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class ButtonCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("TextCollectionViewItem")
        
    lazy var button: NSButton = {
        let button = NSButton()
        button.isBordered = false
        button.imageScaling = .scaleProportionallyDown
        button.font = NSFont.systemFont(ofSize: 13)
        return button
    }()
    
    override func loadView() {
        super.view = NSView()
        setupView()
    }
    
    private func setupView(){
        let container = NSView()
        container._BackgroundColor = NSColor(named: "TouchBarButtonBackgroundColor")
        container.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        NSLayoutConstraint.activate([container.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                                     container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     container.widthAnchor.constraint(equalToConstant: 70),
                                     container.heightAnchor.constraint(equalToConstant: 40)])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(button)
        NSLayoutConstraint.activate([button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                                     button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                                     button.widthAnchor.constraint(greaterThanOrEqualToConstant: 24),
                                     button.heightAnchor.constraint(equalToConstant: 24)])
        
    }
    
    func showAction(action: Action, _ didTap: (()->())?){
        switch action {
        case .plusIcon: button.image = NSImage(named: "PlusIcon")
        default: button.title = "See more"
        }
        
        view.subviews[0].addClickGestureRecognizer { didTap?() }
    }
    
    enum Action {
        case seeMore, plusIcon
    }
}
