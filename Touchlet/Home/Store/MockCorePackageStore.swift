//
//  MockCorePackageStore.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

class MockCorePackageStore: CorePackageStore{
    func addPackageItem(_ item: CorePackageItem) {
    }
    
    func addPackageItems(_ items: [CorePackageItem]) {
        
    }
    
    public static let instance = MockCorePackageStore.init()
    
    func findAll(with type: CorePackageType,  result: @escaping (([CorePackageItem]) -> Void)) {
        switch type {
        case .App:
            let spotlight = SpotlightAssistance.instance
            spotlight.callback = {
                let mapped = $0.sortedItems.map{CorePackageItem(id: $0.bundleIdentifier, type: type, title: $0.displayName, url: nil)}
                result(mapped)
            }
            spotlight.doSpotlightQuery()
        default:
            result([CorePackageItem(id: "AAA", type: type, title: "Title Sample", url: nil)])
        }
    }
}
