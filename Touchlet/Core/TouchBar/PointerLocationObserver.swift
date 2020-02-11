//
//  TouchBarPanelNotification.swift
//  Touchlet
//
//  Created by Elias on 23/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class PointerLocationObserver{
    private let itemDropDetectionHeight = CGFloat(10)
    private var timeInterval: TimeInterval
    private var timer: Timer?
    private var object: Any?
    
    var delegate: PointerLocationObserverDelegate?
        
    init(timeInterval: TimeInterval = 0.1) {self.timeInterval = timeInterval}
    
    func start(_ object: Any?){
        self.object = object
        timer = Timer(timeInterval: timeInterval, repeats: true, block: {_ in
            self.dispatchDelegation(isTerminated: false)
        })
        RunLoop.main.add(timer!, forMode: .default)
    }
    
    private func dispatchDelegation(isTerminated: Bool){
        let mouseLocation = NSEvent.mouseLocation
        let inDropRect = self.inDropDetectionRect(pointer: mouseLocation)
        delegate?.pointerLocationObserver(pointerLocation: mouseLocation, inDropRect: inDropRect, object: object, isTerminated: isTerminated)
    }
    
    func stop(){
        timer?.invalidate()
        dispatchDelegation(isTerminated: true)
    }
    
    func inDropDetectionRect(pointer: NSPoint, screenFrame: NSRect) -> Bool{
        let possibleRect = NSRect(x: 0, y: 0, width: screenFrame.width, height: itemDropDetectionHeight)
        return possibleRect.contains(pointer)
    }
    
    func inDropDetectionRect(pointer: NSPoint) -> Bool{
        if let screenRect = NSScreen.main?.frame{
            return inDropDetectionRect(pointer: pointer, screenFrame: screenRect)
        }
        
        return false
    }
}

protocol PointerLocationObserverDelegate: class{
    func pointerLocationObserver(pointerLocation: NSPoint, inDropRect: Bool, object: Any?, isTerminated: Bool)
}

extension NSNotification.Name{
    static let dragBegin = NSNotification.Name(rawValue: "\(Global.groupIdPrefix).dragBegin")
    static let dragEnded = NSNotification.Name(rawValue: "\(Global.groupIdPrefix).dragEnded")
}
