//
//  TouchBarCollectionItem.swift
//  Touchlet
//
//  Created by Elias on 28/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

class TouchBarCollectionViewItem: NSCollectionViewItem{
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("TouchBarCollectionViewItem")
            
    var image: NSImage? {didSet{(view as! NSButton).image = image}}
    var onTap: (() -> Void)?

    private lazy var button = TouchBarCollectionButton(title: "", target: self, action: #selector(buttonTapped))
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
        self.view = button
        normalState()
    }
    
    @objc func buttonTapped(){
        self.onTap?()
    }
    
    private func browseState(){
        button.setBackgroundColor(NSColor.browseStateColor)
        button.image = image
    }
       
    private func normalState(){
        button.setBackgroundColor(NSColor.normalStateColor)
        button.image = image
    }
    
    private func hiddenState(){
        button.setBackgroundColor(NSColor.hiddenStateColor)
        button.image = image?.greyscale
    }

    enum State{case normal, browse, hidden}
}

fileprivate class TouchBarCollectionButton: NSButton{
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isBordered = false
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    func setBackgroundColor(_ backgroundColor: NSColor?) {
        let cell = (super.cell as! ButtonCell)
        cell._backgroundColor = backgroundColor
        cell.hightlightColor = backgroundColor?.highlight(withLevel: 0.2)
    }
    
    override class var cellClass: AnyClass?{get{return ButtonCell.self} set{}}
        
    class ButtonCell: NSButtonCell {
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
    fileprivate static var hiddenStateColor = Theme.touchBarButtonBackgroundColor.withAlphaComponent(0.4)
}
