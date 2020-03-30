//
//  TextCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 16/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

class ButtonCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("TextCollectionViewItem")
        
    lazy var button: NSButton = {
        let button = NSButton()
        button.isBordered = false
        button.imageScaling = .scaleProportionallyDown
        return button
    }()
    
    override func loadView() {
        super.view = NSView()
        
        let container = NSView()
        container._backgroundColor = Theme.touchBarButtonBackgroundColor
        container.cornerRadius = 20
        view.addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([container.topAnchor.constraint(equalTo: view.topAnchor),
                                     container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     container.widthAnchor.constraint(equalToConstant: 70),
                                     container.heightAnchor.constraint(equalToConstant: 40)])
        
        container.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                                     button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                                     button.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
                                     button.heightAnchor.constraint(equalToConstant: 20)])
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.subviews[0].addTrackingArea(NSTrackingArea(rect: view.subviews[0].bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        if let trackingAreas = view.subviews[0].trackingAreas.first {view.subviews[0].removeTrackingArea(trackingAreas)}
    }
    
    override func mouseEntered(with event: NSEvent) {
        view.subviews[0]._backgroundColor = Theme.touchBarButtonBackgroundColor.highlight(withLevel: 0.1)
    }
    
    override func mouseExited(with event: NSEvent) {
        view.subviews[0]._backgroundColor = Theme.touchBarButtonBackgroundColor
    }
    
    func showAction(action: Action, _ didTap: (()->())?){
        switch action {
        case .plusIcon: button.image = NSImage(named: "AddIcon")
        case .seeMoreIcon: button.image = NSImage(named: "MoreIcon")
        }
        
        view.subviews[0].addClickGestureRecognizer { didTap?() }
    }
    
    enum Action {
        case seeMoreIcon, plusIcon
    }
}
