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

public struct Global {
    public static let groupIdPrefix: String = {
        let bundle = Bundle(identifier: "com.heeleeaz.touchlet.core")
        let groupIdPrefixKey = "GroupIdentifierPrefix"
        guard let groupIdPrefix = bundle?.object(forInfoDictionaryKey: groupIdPrefixKey) as? String else {
            fatalError("Info.plist must contain a \"\(groupIdPrefixKey)\" entry with a string value")
        }
        
        return groupIdPrefix
    }()
}

public let menuAppBundleIdentifier = "com.heeleeaz.touchlet.TouchletMenu"
