//
//  NSImageExtension.swift
//  Touchlet
//
//  Created by Elias on 15/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import CoreImage

extension NSImage{
    
    var data: Data? {return tiffRepresentation}

    var greyscale: NSImage? {
        guard let currentCGImage = cgImage else { return nil}
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return nil }

        if let cgimg = CIContext().createCGImage(outputImage, from: outputImage.extent) {
            return NSImage(cgImage: cgimg, size: size)
        }
        return nil
    }

    var cgImage: CGImage? {
        if let data = tiffRepresentation as NSData?,
            let source = CGImageSourceCreateWithData(data, nil){
            return CGImageSourceCreateImageAtIndex(source, 0, nil) ?? nil
        }
        return nil
    }
    
    func resize(destSize: CGSize) -> NSImage {
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, size.width, size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return newImage
    }
}
