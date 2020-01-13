//
//  NSCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 12/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSCollectionView{
    var contentSize: NSSize?{
        return collectionViewLayout?.collectionViewContentSize
    }
}

@IBDesignable class LNSCollectionView: NSCollectionView{
    override var intrinsicContentSize: NSSize{
        return contentSize ?? NSSize()
    }
    
//    override func scrollWheel(with event: NSEvent) {
//        nextResponder?.resignFirstResponder()
////        nextResponder?.nextResponder?.becomeFirstResponder()
//        
//        (nextResponder?.nextResponder as? NSScrollView)?.becomeFirstResponder()
////        print()
//        //avoid calling super to disable scrolling
//    }
}


@IBDesignable class MYOuterScrollView: NSScrollView, NSGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldReceive touch: NSTouch) -> Bool {
        print("sdvkodfs")
        return false
    }
//    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
        print("sdvkodfs")
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldAttemptToRecognizeWith event: NSEvent) -> Bool {
        print("D")
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        print("C")
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        print("B")
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        print("A")
        return false
    }
}
