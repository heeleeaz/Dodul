//
//  SpotlightResult.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

struct SpotlightResult{
    var items: [SpotlightItem] = []
    
    var filtered: [SpotlightItem] {
        return self.items.filter{!SpotlightRepository.whitelist.contains($0.displayName ?? "")}
    }
    
    func sorted(limit: Int = 10) -> [SpotlightItem] {
        var sorted =  filtered.sorted {$0.lastUsed > $1.lastUsed && $0.useCount > $1.useCount}
        if(limit != -1 && sorted.count > limit){
            sorted.removeSubrange(limit..<sorted.count)
        }
        return sorted
    }
}
