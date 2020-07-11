//
//  TextCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 16/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import AppLib

class ButtonCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("TextCollectionViewItem")
        
    lazy var button: NSButton = {
        let button = NSButton()
        button.isBordered = false
        button.imageScaling = .scaleProportionallyDown
        return button
    }()
    
    private lazy var viewContainer: NSView = {
        let view = NSView()
        view.cornerRadius = 20
        view._backgroundColor = Theme.touchBarButtonBackgroundColor
        return view
    }()
    
    override func loadView() {
        super.view = NSView()
        
        view.addSubview(viewContainer)
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([viewContainer.topAnchor.constraint(equalTo: view.topAnchor),
                                     viewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     viewContainer.widthAnchor.constraint(equalToConstant: 70),
                                     viewContainer.heightAnchor.constraint(equalToConstant: 40)])
        
        viewContainer.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
                                     button.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
                                     button.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
                                     button.heightAnchor.constraint(equalToConstant: 20)])
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if viewContainer.trackingAreas.isEmpty{
            viewContainer.addTrackingArea(NSTrackingArea(rect: viewContainer.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        if let trackingArea = viewContainer.trackingAreas.first {viewContainer.removeTrackingArea(trackingArea)}
    }
    
    override func mouseEntered(with event: NSEvent) {
        viewContainer._backgroundColor = Theme.touchBarButtonBackgroundColor.highlight(withLevel: 0.1)
    }
    
    override func mouseExited(with event: NSEvent) {
        viewContainer._backgroundColor = Theme.touchBarButtonBackgroundColor
    }
    
    func showAction(action: Action, _ didTap: (()->())?){
        switch action {
        case .plusIcon: button.image = NSImage(named: "AddIcon")
        case .seeMoreIcon: button.image = NSImage(named: "MoreIcon")
        }
        
        viewContainer.addClickGestureRecognizer { didTap?() }
    }
    
    enum Action {
        case seeMoreIcon, plusIcon
    }
}
