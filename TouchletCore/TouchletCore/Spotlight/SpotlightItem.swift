//
//  SpotllightItem.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public struct SpotlightItem{
    public let bundleIdentifier: String!
    public let displayName: String?
    public var lastUsed: Date!
    public var useCount: Int!
    
    public static let dummy = SpotlightItem(bundleIdentifier: "", displayName: "", lastUsed: .init(), useCount: 0)
}
