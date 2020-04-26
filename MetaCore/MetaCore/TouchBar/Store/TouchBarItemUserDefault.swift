//
//  TouchItemUserDefault.swift
//  Touchlet
//
//  Created by Elias on 20/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import AppKit

class TouchBarItemUserDefault: TouchBarItemStore {
    public static let shared = TouchBarItemUserDefault()
    
    /**
     true if data as been changed during it shared lifespan
     */
    public var isDirty = false
    
    struct Keys {
        static let touchBarItemKey = "touchBarItemKey"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .touchBarSuite) {
        self.userDefaults = userDefaults
    }
    
    func removeItem(_ item: TouchBarItem) throws {
        var newItems = try findAll()
        newItems.removeAll(where: {$0 == item})
        try setItems(newItems)
    }
    
    func addItem(_ item: TouchBarItem) throws {
        var newItems = try findAll()
        newItems.append(item)
        try setItems(newItems)
    }
    
    func setItems(_ item: [TouchBarItem]) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false)
        userDefaults.set(data, forKey: Keys.touchBarItemKey)
        isDirty = true
    }
    
    func findAll() throws -> [TouchBarItem]{
        guard let data = userDefaults.data(forKey: Keys.touchBarItemKey) else {return []}
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [TouchBarItem]
    }
    
    func compare(_ items: [TouchBarItem]) -> Bool{
        let a = (try? findAll()) ?? []
        if a.count != items.count {return false}
        
        for i in 0..<a.count{
            if a[i] != items[i] {
                return false
            }
        }
        return true
    }
}

extension UserDefaults {
    static let touchBarSuite = UserDefaults(suiteName: "\(Global.shared.APP_SECURITY_GROUP)")!
}
