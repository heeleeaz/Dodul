//
//  AnalyticsConfiguration.swift
//  TouchletCore
//
//  Created by Elias on 18/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class MPAnalyticsConfiguration {
    var analyticsIdentifier: String?
    var duplicateIdentifiers: [AnyHashable : AnyHashable] = [:]

    convenience init() {
        self.init(identifier: nil)
    }

    public init(identifier: String?) {
        analyticsIdentifier = identifier
    }

    public func duplicateEvents(for category: String?, to identifier: String?) {
        if category != nil && identifier != nil {
            duplicateIdentifiers[category ?? ""] = identifier
        }
    }

    public func stopDuplicatingEvents(for category: String?) {
        duplicateIdentifiers.removeValue(forKey: category)
    }
}
