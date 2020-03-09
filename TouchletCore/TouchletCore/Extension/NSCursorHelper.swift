//
//  NSCursorExtension.swift
//  Touchlet
//
//  Created by Elias on 11/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

public class NSCursorHelper{
    private var counter = 0
    
    static var instance = NSCursorHelper()
    
    private init(){
    }
    
    func hide(){
        if counter > 1 {return}
        
        NSCursor.hide()
        counter += 1
    }
    
    func show(){
        while(counter != 0){
            NSCursor.unhide()
            counter -= 1
        }
    }
}
