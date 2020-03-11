//
//  TouchBarCollectionItem.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarCollectionViewItem: NSCollectionViewItem{
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("TouchBarCollectionViewItem")
    
    var image: NSImage? {didSet{(view as! NSButton).image = image}}
    var grayscale: NSImage? = nil
    
    var onTap: (() -> Void)?
    
    private var currentState: State = .normal
    var state: State{
        set{
            switch newValue {
            case .browse:
                if currentState != .browse {browseState()}
            case .hidden:
                if currentState != .hidden {hiddenState()}
            default:
                if currentState != .normal {normalState()}
            }
            currentState = newValue
        }
        
        get{return currentState}
    }
        
    override func loadView() {
        self.view = FlatButton(title: "", target: self, action: #selector(buttonTapped))
        normalState()
    }
    
    @objc func buttonTapped(){
        self.onTap?()
    }
    
    private func browseState(){
        let button = view as! FlatButton
        button.alphaValue = 1
        button.setBackgroundColor(.browseStateColor)
        button.image = image
    }
       
    private func normalState(){
        let button = view as! FlatButton
        
        button.alphaValue = 1
        button.setBackgroundColor(.normalStateColor)
        button.image = image
    }
    
    private func hiddenState(){
        let button = view as! FlatButton
        button.alphaValue = 0.4
        
        if grayscale == nil{
            grayscale = image?.greyscale
        }
        
        button.image = grayscale
    }

    enum State{case normal, browse, hidden}
}

fileprivate class FlatButton: NSButton{
    func setBackgroundColor(_ backgroundColor: NSColor?) {
        isBordered = false
        
        let cell = (super.cell as! FlatButtonCell)
        cell._backgroundColor = backgroundColor
        cell.hightlightColor = backgroundColor?.highlight(withLevel: 0.2)
    }
    
    override class var cellClass: AnyClass?{get{return FlatButtonCell.self} set{}}
        
    class FlatButtonCell: NSButtonCell {
        @nonobjc var hightlightColor: NSColor?
        var _backgroundColor: NSColor?{didSet{backgroundColor = _backgroundColor}}
        
        override func imageRect(forBounds rect: NSRect) -> NSRect {
            let w = CGFloat(24)
            let h = CGFloat(24)
            let x = (rect.width / 2) - (w / 2)
            let y = (rect.height / 2) - (h / 2)
            return NSRect(x: x, y: y, width: w, height: h)
        }
        
        override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
            backgroundColor = flag ? hightlightColor : _backgroundColor
        }
    }
}

extension NSColor{
    fileprivate static var normalStateColor = Theme.touchBarButtonBackgroundColor
    fileprivate static var browseStateColor = Theme.touchBarButtonBackgroundColor.highlight(withLevel: 0.4)
}
