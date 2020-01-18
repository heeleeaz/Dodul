//
//  NSScrollViewExtension.swift
//  Touchlet
//
//  Created by Elias on 12/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

extension NSScrollView{
    func fitContent(){
        if let documentView = contentView.documentView{
            var contentRect = documentView.frame

            for view in documentView.subviews{
                contentRect = contentRect.union(view.frame)
            }
            documentView.setFrameSize(contentRect.size)
        }
    }
}
