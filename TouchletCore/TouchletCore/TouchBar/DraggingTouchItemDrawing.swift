//
//  DraggingTouchItemDrawing.swift
//  TouchletCore
//
//  Created by Elias on 11/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

class DraggingTouchItemDrawing{
    private let cache: Cache<String, NSImage>!
    
    private let canvasSize = CGSize(width: 96, height: 40)
    
    static let instance = DraggingTouchItemDrawing()
    
    private init() {
        self.cache = Cache(dateProvider: {Date()}, entryLifetime: 3600, maximumEntryCount: 10)
        
        if let imageRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                           pixelsWide: Int(canvasSize.width),
                                           pixelsHigh: Int(canvasSize.height),
                                           bitsPerSample: 8, samplesPerPixel: 4,
                                           hasAlpha: true,
                                           isPlanar: false,
                                           colorSpaceName: .deviceRGB,
                                           bitmapFormat: [],
                                           bytesPerRow: 0,
                                           bitsPerPixel: 0), let context = NSGraphicsContext(bitmapImageRep: imageRep){
            
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = context
        }
    }
    
    func draw(_ image: NSImage) -> NSImage?{
        if let cachedImage = cache.entry(forKey: image.description){return cachedImage.value}
        
        guard let context = NSGraphicsContext.current?.cgContext else {return nil}
        
        context.beginPath()
        context.setFillColor(Theme.touchBarButtonBackgroundColor.cgColor)
        context.fill(CGRect(origin: .zero, size: canvasSize))
        
        //draw image to center
        let imageSize = CGSize(width: 26, height: 26)
        let imageOrigin = CGPoint(x: canvasSize.width/2 - imageSize.width/2, y: canvasSize.height/2 - imageSize.height/2)
        context.draw(image.cgImage!, in: CGRect(origin: imageOrigin, size: imageSize))
        
        //draw mouse pointer
        let pointerSize = CGSize(width: 18, height: 24)
        let pointerOrigin = CGPoint(x: canvasSize.width/2 - pointerSize.width/2, y: (canvasSize.height/2 - pointerSize.height/2)-8)
        context.draw(NSCursor.arrow.image.cgImage!, in: CGRect(origin: pointerOrigin, size: pointerSize))
        
        let newImage = NSImage(cgImage: context.makeImage()!, size: canvasSize)
        cache.insert(newImage, forKey: image.description)
        
        return newImage
    }
}
