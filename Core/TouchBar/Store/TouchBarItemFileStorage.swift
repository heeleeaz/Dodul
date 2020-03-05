//
//  TouchBarItemFileStorage.swift
//  Core
//
//  Created by Elias on 05/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class TouchBarItemFileStorage: TouchBarItemStore{
    private var cache: Cache<String, TouchBarItem>
    
    init() {
        cache = Cache(dateProvider: {return Date()}, entryLifetime: .infinity, maximumEntryCount: 1000)
    }
    func setItems(_ item: [TouchBarItem]) throws {
        
    }
    
    func findAll() throws -> [TouchBarItem] {
        <#code#>
    }
    
    func addItem(_ item: TouchBarItem) throws {
        <#code#>
    }
    
    
}
