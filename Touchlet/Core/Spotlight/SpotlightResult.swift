//
//  SpotlightResult.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

class SpotlightResult{
    private var items: [SpotlightItem] = []
    
    init(items: [SpotlightItem]) {
        self.items = items
    }

    lazy var sortedItems = {
        return items.sorted {$0.lastUsed ?? Date.init(timeIntervalSince1970: 0) > $1.lastUsed ?? Date.init(timeIntervalSince1970: 0)}
    }()
}
