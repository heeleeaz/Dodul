//
//  TouchBarPanelNotification.swift
//  Touchlet
//
//  Created by Elias on 23/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class PointerLocationObserver{
    private let itemDropDetectionHeight = CGFloat(40)
    private var timeInterval: TimeInterval
    private var timer: Timer?
    
    var delegate: PointerLocationObserverDelegate?
    
    init(timeInterval: TimeInterval = 0.5) {self.timeInterval = timeInterval}
    
    func start(_ object: Any?){
        timer = Timer(timeInterval: timeInterval, repeats: true, block: {_ in
            let mouseLocation = NSEvent.mouseLocation
            let inDropRect = self.inDropDetectionRect(pointer: mouseLocation)
            self.delegate?.pointerLocationObserver(pointerLocation: mouseLocation, inDropRect: inDropRect, object: object)
        })
        RunLoop.main.add(timer!, forMode: .default)
    }
    
    func stop(){timer?.invalidate()}
    
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
    func pointerLocationObserver(pointerLocation: NSPoint, inDropRect: Bool, object: Any?)
}

extension NSNotification.Name{
    static let dragBegin = NSNotification.Name(rawValue: "\(Global.groupIdPrefix).dragBegin")
    static let dragEnded = NSNotification.Name(rawValue: "\(Global.groupIdPrefix).dragEnded")
}
