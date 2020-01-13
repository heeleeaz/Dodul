//
//  NSScrollViewExtension.swift
//  Touchlet
//
//  Created by Elias on 12/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSScrollView{
    func resizeScrollViewContentSize(){

        let contentRect: CGRect = subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
                
//        print(contentRect)
//        documentView?.setFrameSize(contentRect.size)
        hasVerticalScroller = true
//        showsHorizontalScrollIndicator = true
//        showsVerticalScrollIndicator = true
//        contentSize = contentRect.size
    }
}
