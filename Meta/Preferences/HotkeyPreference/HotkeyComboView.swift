//
//  KeybindTagView.swift
//  Touchlet
//
//  Created by Elias on 26/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

@IBDesignable public class HotkeyComboView: NSStackView{
    
    @IBInspectable var font: NSFont = NSFont.systemFont(ofSize: 18, weight: .light)
    
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
    
    func removeAll(){
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func addKey(_ character: Character, isEditing: Bool){
        let hotkey = HotkeyCharacter(character: character, isEditing: isEditing)
        hotkey.font = font
        addArrangedSubview(hotkey)
    }
}

class HotkeyCharacter: NSButton{
    var isEditing: Bool = false{
        didSet{
            updateView()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override var intrinsicContentSize: NSSize{
        let width = super.intrinsicContentSize.width + (super.intrinsicContentSize.width / 2)
        let height = superview?.frame.height ?? super.intrinsicContentSize.height
        return NSSize(width: width, height: height)
    }
    
    convenience init(character: Character, isEditing: Bool) {
        self.init(frame: .zero)
        self.title = String(character)
        self.isEditing = isEditing
    }
    
    private func setupView(){
        self.bezelStyle = .smallSquare
        self.cornerRadius = 2
    }
    
    private func updateView(){
        self._backgroundColor = DarkTheme.hotkeyBackgroundColor
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {return nil}
}
