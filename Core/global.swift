//
//  Global.swift
//  Touchlet
//
//  Created by Elias on 10/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

#if DEBUG
public let isDebugBuild = true
#else
public let isDebugBuild = false
#endif

struct Global {
    public static let groupIdPrefix: String = "Touchlet"
}
