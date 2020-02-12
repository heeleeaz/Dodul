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
    private var objectDictionary = [StartCondition : Any]()
    
    var delegate: PointerLocationObserverDelegate?
    
    var isTriggerEmpty: Bool {return objectDictionary.isEmpty}
        
    init(timeInterval: TimeInterval = 0.1) {
        self.timeInterval = timeInterval
        
        timer = Timer(timeInterval: timeInterval, repeats: true, block: {_ in
            if self.objectDictionary.isEmpty {
                self.dispatchDelegation()
            }else{
                for key in self.objectDictionary.keys{
                    self.dispatchStartConditionDelegation(startCondition: key, isTerminated: false)
                }
            }
        })
        RunLoop.main.add(timer!, forMode: .default)
    }
    
    func invalidate(){
        timer?.invalidate()
        objectDictionary.removeAll()
    }
    
    func begin(startCondition: StartCondition, object: Any?){
        objectDictionary[startCondition] = object
    }
    
    func end(startCondition: StartCondition){
        dispatchStartConditionDelegation(startCondition: startCondition, isTerminated: true)
        objectDictionary.removeValue(forKey: startCondition)
    }
    
    private func dispatchDelegation(){
        let mouseLocation = NSEvent.mouseLocation
        let inDropRect = self.inDropDetectionRect(pointer: mouseLocation)
        
        delegate?.pointerLocationObserver(observer: self, pointerLocation: mouseLocation, inDropRect: inDropRect)
    }
    
    private func dispatchStartConditionDelegation(startCondition: StartCondition, isTerminated: Bool){
        let mouseLocation = NSEvent.mouseLocation
        let inDropRect = self.inDropDetectionRect(pointer: mouseLocation)
        delegate?.pointerLocationObserver(observer: self, startCondition: startCondition, pointerLocation: mouseLocation, inDropRect: inDropRect, object: objectDictionary[startCondition], isTerminated: isTerminated)
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
    
    enum StartCondition {
        case drag, inRadius
    }
}

protocol PointerLocationObserverDelegate: class{
    func pointerLocationObserver(observer: PointerLocationObserver, pointerLocation: NSPoint, inDropRect: Bool)
    
    func pointerLocationObserver(observer: PointerLocationObserver, startCondition: PointerLocationObserver.StartCondition, pointerLocation: NSPoint, inDropRect: Bool, object: Any?, isTerminated: Bool)
}

extension NSNotification.Name{
    static let dragBegin = NSNotification.Name(rawValue: "\(Global.groupIdPrefix).dragBegin")
    static let dragEnded = NSNotification.Name(rawValue: "\(Global.groupIdPrefix).dragEnded")
}
