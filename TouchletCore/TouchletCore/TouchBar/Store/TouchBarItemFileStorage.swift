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
        cache = (try? Cache.loadFromDisk(withName: Keys.main)) ?? Cache()
    }
    
    func setItems(_ item: [TouchBarItem]) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false)
        cache.insert(data, forKey: Keys.main)
        try cache.saveToDisk(withName: Keys.main)
    }
    
    func findAll() throws -> [TouchBarItem] {
        guard let data = cache.value(forKey: Keys.main) else {return []}
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [TouchBarItem]
    }
    
    func addItem(_ item: TouchBarItem) throws {
        var newItems = try findAll()
        newItems.append(item)
        try setItems(newItems)
    }
    
    struct Keys {
        static let main = "\(Global.groupIdPrefix).touchBarItemKeys_"
    }
}
