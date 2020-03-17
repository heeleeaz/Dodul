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
    
    private lazy var indicatorImage: NSImageView = {
        let imageView = NSImageView()
        imageView.image = NSImage(named: "DragIcon180")
        return imageView
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
    
    private func postInit(){
        addSubview(indicatorImage)
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
        
      indicatorImage.wantsLayer = true
      indicatorImage.layer?.add(floatAnimation, forKey: "positionAnimation")
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        
        if indicatorImage.layer?.animation(forKey: "positionAnimation") == nil{
            indicatorImage.layer?.add(floatAnimation, forKey: "positionAnimation")
        }
    }
}


class EmptyTouchBarItemInitView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        postInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        postInit()
    }
    private func postInit(){
        let text = NSText()
        text.textColor = .white
        text.font = NSFont.systemFont(ofSize: 14)
        text.string = "Add new shortcut"
        addSubview(text)
    
        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
                                     text.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     text.heightAnchor.constraint(equalToConstant: 16),
                                     text.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)])
        
        
        let button = NSButton(title: "Add", target: self, action: #selector(addButtonClicked))
        button.font = NSFont.systemFont(ofSize: 14)
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: text.trailingAnchor, constant: 5),
                                     button.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     button.heightAnchor.constraint(equalToConstant: 16),
                                     button.widthAnchor.constraint(equalToConstant: 60)])
    }
    
    @objc private func addButtonClicked(){
        print("clicked")
    }
}
