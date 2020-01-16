//
//  SpotlightResult.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class SpotlightResult{
    private var items: [SpotlightItem] = []
    
    init(items: [SpotlightItem]) {
        self.items = items
    }

    func sortedItems(exempt: [String] = SpotlightRepository.whitelist) -> [SpotlightItem] {
        let filtered = items.filter{!exempt.contains($0.displayName ?? "")}
        return filtered.sorted {$0.lastUsed > $1.lastUsed && $0.useCount > $1.useCount}
    }

}
