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
        view.alphaValue = 1
        (view as! FlatButton).setBackgroundColor(.browseStateColor)
    }
       
    private func normalState(){
        view.alphaValue = 1
        (view as! FlatButton).setBackgroundColor(.normalStateColor)
    }
    
    private func hiddenState(){
        view.alphaValue = 0.4
        (view as! FlatButton).image = image?.greyscale
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
    fileprivate static var normalStateColor = NSColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1)
    fileprivate static var browseStateColor = NSColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
}
