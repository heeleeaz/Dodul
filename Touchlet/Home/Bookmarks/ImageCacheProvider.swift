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
    private static let updateQueue = DispatchQueue(label: "Cache update queue", qos: .utility)
    private static let filename = String(describing: FaviconImageProvider.self)
    private let lock = NSLock()
    
    public typealias ImageCacheProviderCompletion = ((NSImage?, Error?)->Void)
    private var cache: Cache<String, Data>!
    
    public static let instance = FaviconImageProvider()
    
    private init() {
        cache = (try? Cache<String, Data>.loadFromDisk(withName: FaviconImageProvider.filename)) ?? Cache<String, Data>()
    }
    
    func load(url: URL, completion: @escaping ImageCacheProviderCompletion){
        if let bitmap = cache.value(forKey: url.absoluteString)?.bitmap{
            let image = NSImage()
            image.addRepresentation(bitmap)
            completion(image, nil)
        }else{
            try? FavIcon.downloadPreferred(url, width: 400, height: 400, completion: {
                switch $0{
                case .success(let image):
                    guard let data = image.data else {return}
                    
                    self.lock.lock()
                    self.cache.insert(data, forKey: url.absoluteString)
                    try? self.cache.saveToDisk(withName: FaviconImageProvider.filename)
                    self.lock.unlock()
                    
                    completion(image, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            })
        }
    }

}
