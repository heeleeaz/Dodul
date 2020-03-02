//
//  KeybindTagView.swift
//  Touchlet
//
//  Created by Elias on 26/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class KeybindTagView: NSStackView{
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        postInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        postInit()
    }
    
    private func postInit(){
        self.orientation = .horizontal
        self.alignment = .centerY
        self.distribution = .equalSpacing
        
        //remove all width constraint
        constraints.forEach{if $0.firstAttribute == .width {removeConstraint($0)}}
        NSLayoutConstraint.activate([widthAnchor.constraint(greaterThanOrEqualToConstant: 50)])
    }
    
    func removeAllTags(){
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func addTagItem(_ title: String, isEditing: Bool){
        addArrangedSubview(KeybindTagViewItem(title: title, isEditing: isEditing))
    }
}

class KeybindTagViewItem: NSButton{
    var isEditing: Bool = false{didSet{updateView()}}
    var buttonSpacingExtra = NSSize(width: 10, height: 10)
    var defaultFont = NSFont.systemFont(ofSize: 15)
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override var intrinsicContentSize: NSSize{
        let width = super.intrinsicContentSize.width + buttonSpacingExtra.width
        let height = superview?.frame.height ?? super.intrinsicContentSize.height
        return NSSize(width: width, height: height)
    }
    
    convenience init(title: String, isEditing: Bool) {
        self.init(frame: .zero)
        self.title = title
        self.isEditing = isEditing
    }
    
    private func setupView(){
        self.bezelStyle = .smallSquare
        self.font = defaultFont
        self.cornerRadius = 2
    }
    
    private func updateView(){
        self._BackgroundColor = .hotkeyBackgroundColor
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {return nil}
}
