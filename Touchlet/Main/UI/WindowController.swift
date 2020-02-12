//
//  WindowController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController{
    private let pointerLocationObserver = PointerLocationObserver()
    private let touchBarItemUserDefault = TouchBarItemUserDefault.instance
    
    lazy var placeDemoView: TouchBarItemButton = {return TouchBarItemButton(image: nil)}()
    lazy var documentView: NSStackView = {return NSStackView(frame: NSRect.zero)}()
    
    open var animatedButtonBorderSet: Set<Int> = Set()
    
    final lazy var touchBarItems: [TouchBarItem] = {
        return (try? TouchBarItemUserDefault.instance.findAll()) ?? []
    }()
    
    private var volatileTouchBarItems = [TouchBarItem]()

    func volatileItemContains(_ item: TouchBarItem) -> Bool{return volatileTouchBarItems.contains(item)}
    
    func findInVolatileItem(_ index: Int) -> TouchBarItem?{
        return (index>=0 && index < volatileTouchBarItems.count) ? volatileTouchBarItems[index] : nil
    }
    
    func appendVolatileList(_ item: TouchBarItem){ volatileTouchBarItems.append(item)}

    func removeVolatileList(_ item: TouchBarItem){volatileTouchBarItems.removeAll { $0 == item}}
    
    private func registerNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(collectionItemDragBegin), name: .dragBegin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(collectionItemDragEnded), name: .dragEnded, object: nil)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.setFrameAutosaveName("WindowAutosave")
        
        pointerLocationObserver.delegate = self
        registerNotificationObservers()
    }
    
    @objc private func collectionItemDragBegin(notification: NSNotification){
        pointerLocationObserver.begin(startCondition: .drag, object: notification.object)
    }
    
    @objc private func collectionItemDragEnded(notification: NSNotification){
        pointerLocationObserver.end(startCondition: .drag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        pointerLocationObserver.invalidate()
    }
}

