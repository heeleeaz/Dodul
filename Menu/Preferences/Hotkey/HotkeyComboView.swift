//
//  KeybindTagView.swift
//  Touchlet
//
//  Created by Elias on 26/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

@IBDesignable public class HotkeyComboView: NSStackView{
    @IBInspectable var fontSize: CGFloat = 18
    
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
        
        clearView()
    }
    
    func clearView(){
        //remove all width constraint
        constraints.forEach{if $0.firstAttribute == .width {removeConstraint($0)}}
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: spacing)])
        
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func addKey(_ character: Character, isEditing: Bool = false){
        let hotkeyCharacter = HotkeyCharacter(labelWithString: String(character))
        hotkeyCharacter.font = NSFont.systemFont(ofSize: fontSize, weight: .light)
        hotkeyCharacter._backgroundColor = DarkTheme.hotkeyBackgroundColor

        if isEditing{
            hotkeyCharacter.textColor = DarkTheme.textColor?.withAlphaComponent(0.4)
        }else{
            hotkeyCharacter.textColor = DarkTheme.textColor
        }
        
        hotkeyCharacter.cornerRadius = 4
        addArrangedSubview(hotkeyCharacter)
                
        widthConstaint?.constant = (widthConstaint?.constant ?? 0) + hotkeyCharacter.intrinsicContentSize.width
    }
    
    private class HotkeyCharacter: NSTextField{
        override var intrinsicContentSize: NSSize{
            super.alignment = .center
            return NSSize(width: super.intrinsicContentSize.height, height: super.intrinsicContentSize.height)
        }
    }
}
