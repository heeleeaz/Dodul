//
//  EmptyTouchItemListView.swift
//  TouchletCore
//
//  Created by Elias on 16/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

class EmptyTouchBarItemInfoView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        postInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        postInit()
    }
    
    private func postInit(){
        let indicatorImage = NSImageView()
        addSubview(indicatorImage)
        indicatorImage.image = NSImage(named: "DragIcon180")!
        indicatorImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([indicatorImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     indicatorImage.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     indicatorImage.widthAnchor.constraint(equalToConstant: 22),
                                     indicatorImage.heightAnchor.constraint(equalToConstant: 22)])
        
        let text = NSText()
        text.textColor = .white
        text.font = NSFont.systemFont(ofSize: 14)
        text.string = "Drag item here"
        addSubview(text)
    
        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([text.leadingAnchor.constraint(equalTo: indicatorImage.trailingAnchor, constant: 5),
                                     text.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     text.heightAnchor.constraint(equalToConstant: 16),
                                     text.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)])
        
        let floatAnimation = CABasicAnimation(keyPath: "position")
        floatAnimation.fromValue = [0, 3]
        floatAnimation.toValue = [0, 0]
        floatAnimation.repeatCount = .greatestFiniteMagnitude
        floatAnimation.duration = 0.3
        floatAnimation.autoreverses = true
        
        indicatorImage.wantsLayer = true
        indicatorImage.layer?.add(floatAnimation, forKey: "positionAnimation")
    }
}
