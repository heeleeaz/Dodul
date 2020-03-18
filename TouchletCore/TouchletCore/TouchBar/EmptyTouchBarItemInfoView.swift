//
//  EmptyTouchItemListView.swift
//  TouchletCore
//
//  Created by Elias on 16/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

class EditableEmptyCollectionTouchBarItem: NSCustomTouchBarItem {
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    private lazy var indicatorImage: NSImageView = {
        let imageView = NSImageView(); imageView.image = NSImage(named: "DragIcon180"); return imageView
    }()
    
    private lazy var floatAnimation: CABasicAnimation = {
        let floatAnimation = CABasicAnimation(keyPath: "position")
        floatAnimation.fromValue = [0, 3]
        floatAnimation.toValue = [0, 0]
        floatAnimation.repeatCount = .greatestFiniteMagnitude
        floatAnimation.duration = 0.3
        floatAnimation.autoreverses = true
        return floatAnimation
    }()
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        self.view = NSView()
        
        view.addSubview(indicatorImage)
        indicatorImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([indicatorImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     indicatorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     indicatorImage.widthAnchor.constraint(equalToConstant: 22),
                                     indicatorImage.heightAnchor.constraint(equalToConstant: 22)])
            
        let text = NSText()
        text.textColor = .white
        text.font = NSFont.systemFont(ofSize: 14)
        text.string = "Drag item here"
        view.addSubview(text)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([text.leadingAnchor.constraint(equalTo: indicatorImage.trailingAnchor, constant: 5),
                                     text.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     text.heightAnchor.constraint(equalToConstant: 16),
                                     text.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)])
            
        indicatorImage.wantsLayer = true
        indicatorImage.layer?.add(floatAnimation, forKey: "positionAnimation")
    }
}

class ReadonlyEmptyCollectionTouchBarItem: NSCustomTouchBarItem {
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        
        self.view = NSView()
        
        let text = NSText()
        text.textColor = .white
        text.font = NSFont.systemFont(ofSize: 14)
        text.string = "Add new shortcuts"
        view.addSubview(text)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([text.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                                     text.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     text.heightAnchor.constraint(equalToConstant: 16),
                                     text.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)])
            
            
        let button = NSButton(title: "Add", target: self, action: #selector(addButtonClicked))
        button.font = NSFont.systemFont(ofSize: 14)
        view.addSubview(button)
            
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: text.trailingAnchor, constant: 5),
                                     button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     button.heightAnchor.constraint(equalToConstant: 30),
                                     button.widthAnchor.constraint(lessThanOrEqualToConstant: 80)])
    }
    
    @objc private func addButtonClicked(){
        NSWorkspace.shared.launchApplication(withBundleIdentifier: menuAppBundleIdentifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
}

class EditButtonTouchBarItem: NSCustomTouchBarItem {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
    
        let button = NSButton(image: NSImage(named: "EditIcon")!, target: self, action: #selector(buttonTapped))
        
        view = button
        view.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([view.widthAnchor.constraint(equalToConstant: 30),
                                     view.heightAnchor.constraint(equalToConstant: 30)])
        
    }
    
    @objc private func buttonTapped(){
        NSWorkspace.shared.launchApplication(withBundleIdentifier: menuAppBundleIdentifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
}
