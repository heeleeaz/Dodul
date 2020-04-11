//
//  OuterScrollView.swift
//  Touchlet
//
//  Created by Elias on 15/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

@IBDesignable open class OuterScrollView: NSScrollView, NSGestureRecognizerDelegate{
    private var currentScrollMatches: Bool = false
    private var scrollDirection: ScrollDirection = ScrollDirection.vertical

    override open func scrollWheel(with event: NSEvent){
        if event.phase == .mayBegin {
            super.scrollWheel(with: event)
            nextResponder?.scrollWheel(with: event)
            return
        }

        /*
         Check the scroll direction only at the beginning of a gesture for modern scrolling devices
         Check every event for legacy scrolling devices
         */
        if event.phase == .began || (event.phase == [] && event.momentumPhase == []){
            switch scrollDirection {
            case .vertical:
                currentScrollMatches = abs(event.scrollingDeltaX) > abs(event.scrollingDeltaY)
            case .horizontal:
                currentScrollMatches = abs(event.scrollingDeltaY) > abs(event.scrollingDeltaX)
            }
        }

        if currentScrollMatches {
            super.scrollWheel(with: event)
        } else {
            self.nextResponder?.scrollWheel(with: event)
        }
    }
    
    private enum ScrollDirection { case vertical, horizontal }
}
