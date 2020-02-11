//
//  WindowController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController{
    public let pointerLocationObserver = PointerLocationObserver()
    
    lazy var skeletaButtonView: SkeletaTouchBarItemView = {return SkeletaTouchBarItemView()}()

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.setFrameAutosaveName("WindowAutosave")
        
        pointerLocationObserver.delegate = self
        registerNotificationObservers()
    }
    
    private func registerNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(collectionItemDragBegin), name: .dragBegin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(collectionItemDragEnded), name: .dragEnded, object: nil)
    }
    
    @objc private func collectionItemDragBegin(notification: NSNotification){
        pointerLocationObserver.start(notification.object)
    }
    
    @objc private func collectionItemDragEnded(notification: NSNotification){
        pointerLocationObserver.stop()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

