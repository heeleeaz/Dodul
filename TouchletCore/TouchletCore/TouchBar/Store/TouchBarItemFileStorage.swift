//
//  TouchBarItemFileStorage.swift
//  Core
//
//  Created by Elias on 05/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class TouchBarItemFileStorage: TouchBarItemStore{
    static let instance = TouchBarItemFileStorage()

    private var cache: Cache<String, Data>
    
    init() {
        cache = (try? Cache.loadFromDisk(withName: Constant.cachePath)) ?? Cache()
    }
    
    func setItems(_ item: [TouchBarItem]) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false)
        cache.insert(data, forKey: Constant.cachePath)
        try cache.saveToDisk(withName: Constant.cachePath)
    }
    
    func findAll() throws -> [TouchBarItem] {
        guard let data = cache.value(forKey: Constant.cachePath) else {return []}
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [TouchBarItem]
    }
    
    func addItem(_ item: TouchBarItem) throws {
        var newItems = try findAll()
        newItems.append(item)
        try setItems(newItems)
    }
    
    struct Constant {
        static let cachePath = "touchBarItems"
    }
}
