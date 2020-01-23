//
//  TouchBarPanelNotification.swift
//  Touchlet
//
//  Created by Elias on 23/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

public class PointerLocationObserver{
    private let itemDropDetectionHeight = CGFloat(40)
    private var timeInterval: TimeInterval
    private var timer: Timer?
    
    init(timeInterval: TimeInterval = 0.5) {self.timeInterval = timeInterval}
    
    func start(delegate: @escaping (NSPoint, Bool)->()){
        timer = Timer(timeInterval: timeInterval, repeats: true, block: {_ in
            let mouseLocation = NSEvent.mouseLocation
            delegate(mouseLocation, self.inDropDetectionRect(pointer: mouseLocation))
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
