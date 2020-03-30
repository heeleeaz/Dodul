//
//  SpotlightResult.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

public class SpotlightResult{
    public var position = 0
    public var items: [SpotlightItem] = []
    
    init(items: [SpotlightItem]) {
        self.items = items.filter{!SpotlightRepository.whitelist.contains($0.displayName ?? "")}
        sortByRecentUsage()
    }

    public var hasNext: Bool{ return position < items.count}
    
    public func next(forward by: Int) -> [SpotlightItem]{
        let arr =  Array(items[position ..< min((by + position), count)])        
        position += arr.count
        return arr
    }
    
    public var count: Int { return items.count }
    
    public func sortAlphabetically(){
        self.items = items.sorted {$0.displayName?.lowercased() ?? "" < $1.displayName?.lowercased() ?? ""}
    }
    
    public func sortByRecentUsage(){
        self.items = items.sorted {$0.lastUsed > $1.lastUsed && $0.useCount > $1.useCount}
    }
    
    public func reset() -> Int{
        defer{
            position = 0
        }
        return position
    }
}
