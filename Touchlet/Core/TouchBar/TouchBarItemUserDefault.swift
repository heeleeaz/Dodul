//
//  TouchItemUserDefault.swift
//  Touchlet
//
//  Created by Elias on 20/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

class TouchBarItemUserDefault: TouchBarItemStore {
    static let instance = TouchBarItemUserDefault()
    
    struct Keys {
        static let touchBarItemKey = "com.heeleeaz.touchBarItem.touchBarItemKey"
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
        
        //notification seems not to fire, hence, post notification manually for now
        NotificationCenter.default.post(name: .TouchBarItem, object: item)
    }
    
    func findAll() throws -> [TouchBarItem]{
        guard let data = userDefaults.data(forKey: Keys.touchBarItemKey) else {return []}
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [TouchBarItem]
    }
}

extension UserDefaults {
    static let touchBarSuite = UserDefaults(suiteName: "\(Global.groupIdPrefix).touchBarItem_")!
}

extension NSNotification.Name{
    static let TouchBarItem = NSNotification.Name(TouchBarItemUserDefault.Keys.touchBarItemKey)
}
