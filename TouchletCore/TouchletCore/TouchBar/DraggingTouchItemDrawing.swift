//
//  DraggingTouchItemDrawing.swift
//  TouchletCore
//
//  Created by Elias on 11/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

class DraggingTouchItemDrawing{
    private let cache: Cache<String, NSImage>!
    
    private let canvasSize = CGSize(width: 140, height: 58)
    
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
        
        //draw grey container
        let boxSize = CGSize(width: 90, height: 40)
        let boxOrigin = CGPoint(x: 0, y: 20)
        context.fill(CGRect(origin: boxOrigin, size: boxSize))
        
        //draw image to container center
        let imgSize = CGSize(width: 26, height: 26)
        let imgOrigin = CGPoint(x: (boxSize.width/2 - imgSize.width/2) + boxOrigin.x, y: (boxSize.height/2 - imgSize.height/2) + boxOrigin.y)
        context.draw(image.cgImage!, in: CGRect(origin: imgOrigin, size: imgSize))
        
        //draw mouse pointer
        let pointerSize = CGSize(width: 18, height: 24)
        let pointerOrigin = CGPoint(x: -4, y: pointerSize.height + 14)
        context.draw(NSCursor.arrow.image.cgImage!, in: CGRect(origin: pointerOrigin, size: pointerSize))
        
        let newImage = NSImage(cgImage: context.makeImage()!, size: canvasSize)
        cache.insert(newImage, forKey: image.description)
        
        return newImage
    }
}
