//
//  StorageCacheProvider.swift
//  Touchlet
//
//  Created by Elias on 15/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import Cocoa
import FavIcon

class FaviconImageProvider{
    public static let instance = FaviconImageProvider()
    
    private static let updateQueue = DispatchQueue(label: "Cache update queue", qos: .utility)
    private static let filename = String(describing: FaviconImageProvider.self)
    private let faviconImageCacheSize = NSSize(width: 24, height: 24)
    private var cache: Cache<String, Data>!
    private var lock = NSLock()
    
    public typealias ImageCacheProviderCompletion = ((NSImage?, Error?)->Void)
    
    private init() {
        cache = (try? Cache<String, Data>.loadFromDisk(withName: FaviconImageProvider.filename))
            ?? Cache<String, Data>()
    }
    
    func load(fromCache url: URL) -> NSImage?{
        guard let bitmap = cache.value(forKey: url.absoluteString)?.bitmap else {
            return nil
        }
        
        let image = NSImage()
        image.addRepresentation(bitmap)
        return image
    }
    
    func download(url: URL, completion: @escaping ImageCacheProviderCompletion) throws{
        try FavIcon.downloadPreferred(url, width: 512, height: 512, completion: {
            switch $0{
            case .success(let image):
                if let data = image.resize(destSize: self.faviconImageCacheSize).data{
                    self.cache.insert(data, forKey: url.absoluteString)
                    try? self.cache.saveToDisk(withName: FaviconImageProvider.filename)
                    completion(image, nil)
                }else{
                    completion(nil, nil)
                }
            case .failure(let error): completion(nil, error)
            }
        })
    }
    
    func load(url: URL, completion: @escaping ImageCacheProviderCompletion){
        if let image = load(fromCache: url){
            completion(image, nil)
        }else{
            do{
                try download(url: url, completion: completion)
            } catch let error as NSError{
                completion(nil, error)
            }
        }
    }
}
