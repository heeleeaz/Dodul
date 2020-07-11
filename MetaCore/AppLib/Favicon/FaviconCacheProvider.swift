//
//  StorageCacheProvider.swift
//  Touchlet
//
//  Created by Elias on 15/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import AppKit

public class FaviconCacheProvider{
    public static let shared = FaviconCacheProvider()
    
    private var cache: Cache<String, Data>!
    
    struct Constant {
        public static let cachePath = String(describing: FaviconCacheProvider.self)
    }
    
    private init() {
        cache = (try? Cache.loadFromDisk(withName: Constant.cachePath)) ?? Cache()
    }
    
    public func reload(){
        cache = (try? Cache.loadFromDisk(withName: Constant.cachePath)) ?? Cache()
    }
    
    public func loadFromCache(path: String) -> NSImage?{
        if let bitmap = cache.value(forKey: path)?.bitmap {
            let image = NSImage()
            image.addRepresentation(bitmap)
            return image
        }
        return nil
    }
    
    public func insert(_ image: NSImage, path: String){
        if let data = image.data{insert(data, path: path)}
    }
    
    public func insert(_ imageRepresentation: Data, path: String){
        cache.insert(imageRepresentation, forKey: path)
        try? cache.saveToDisk(withName: Constant.cachePath)
    }
}
