//
//  StorageCacheProvider.swift
//  Touchlet
//
//  Created by Elias on 15/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import Cocoa
//import FavIcon

class FaviconProvider{
    public static let instance = FaviconProvider()
    
    private static let updateQueue = DispatchQueue(label: "UpdateQueue", qos: .utility)
    private var cache: Cache<String, Data>!
    
    public typealias ImageCacheProviderCompletion = ((NSImage?, Error?)->Void)
    
    struct Constant {
        static let cachePath = String(describing: FaviconProvider.self)
        static let iconSize = NSSize(width: 36, height: 36)
    }
    
    private init() {
        cache = (try? Cache.loadFromDisk(withName: Constant.cachePath)) ?? Cache()
    }
    
    func loadFromCache(url: URL) -> NSImage?{
        if let bitmap = cache.value(forKey: url.absoluteString)?.bitmap {
            let image = NSImage(); image.addRepresentation(bitmap); return image
        }
        return nil
    }
    
    func loadFromNetwork(url: URL, completion: @escaping ImageCacheProviderCompletion){
        do{
            let size = Constant.iconSize
            try FavIcon.downloadPreferred(url, width: Int(size.width), height: Int(size.height)){
                switch $0{
                case .success(let image):
                    if let data = image.resize(destSize: Constant.iconSize).data {
                        self.cache.insert(data, forKey: url.absoluteString)
                        try? self.cache.saveToDisk(withName: Constant.cachePath)
                        completion(image, nil)
                    }
                case .failure(let error): completion(nil, error)
                }
            }
        }catch let error as NSError{completion(nil, error)}
    }
    
    func load(url: URL, completion: @escaping ImageCacheProviderCompletion){
        if let image = loadFromCache(url: url){completion(image, nil)}
        else{loadFromNetwork(url: url, completion: completion)}
    }
}
