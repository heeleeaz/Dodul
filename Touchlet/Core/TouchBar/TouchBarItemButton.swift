//
//  TouchBarItemButton.swift
//  Touchlet
//
//  Created by Elias on 12/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarItemButton: NSView  {
    private var buttonSize = TouchBarUtil.Constant.touchItemButtonSize
    private var defaultCornerRadius = CGFloat(4)
    
    private var currentState: State = .normal
    var state: State{
        set{
            switch newValue {
            case .browse:
                if currentState != .browse {browseState()}
            case .drag:
                if currentState != .drag {dragState()}
            default:
                if currentState != .normal {normalState()}
            }
            currentState = newValue
        }
        
        get{return currentState}
    }
    
    lazy var imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = NSImageScaling.scaleProportionallyDown
        
        return imageView
    }()
    
    init(image: NSImage?) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: buttonSize))
        setupView()
        normalState()
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        cornerRadius = defaultCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func browseState(){
        _BackgroundColor = .black
        if currentState != .drag {TouchBarUtil.animateBorder(of: self, bounds: bounds)}
    }
    
    private func dragState(){
        _BackgroundColor = .black
        if currentState != .browse {TouchBarUtil.animateBorder(of: self, bounds: bounds)}
    }
    
    private func normalState(){
        _BackgroundColor = .touchBarButtonColor
        if currentState != .normal {TouchBarUtil.removeAnimatedBorder(of: self)}
    }
    
    enum State{case normal, browse, drag}
}
