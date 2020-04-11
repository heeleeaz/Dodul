//
//  NSCursorExtension.swift
//  Touchlet
//
//  Created by Elias on 11/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class NSCursorHelper{
    private var counter = 0
    
    public static var instance = NSCursorHelper()
    
    private init(){
    }
    
    public func hide(){
        if counter > 1 {return}
        
        NSCursor.hide()
        counter += 1
    }
    
    public func show(){
        while(counter != 0){
            NSCursor.unhide()
            counter -= 1
        }
    }
    
    public var isHidden: Bool {counter != 0}
}
