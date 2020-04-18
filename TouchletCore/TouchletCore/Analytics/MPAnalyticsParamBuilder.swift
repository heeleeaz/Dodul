//
//  AnalyticsParamBuilder.swift
//  TouchletCore
//
//  Created by Elias on 18/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class MPTrackingRequestParams: NSObject {
    var hitType: String
    var contentDescription: String?
    
    public init(hitType: String, contentDescription: String?){
        self.hitType = hitType
        self.contentDescription = contentDescription
    }
        
    public func dictionaryRepresentationKeys() -> [String: Any?] {[:]}

    public final func dictionaryRepresentation() -> [String: Any]? {
        var defDict: [String: Any?] = [MPHitTypeKey:hitType, MPContentDescriptionKey:contentDescription]
        return defDict.merge(dictionaryRepresentationKeys()).compactMapValues{$0}
    }
}

public class MPEventParams: MPTrackingRequestParams {
    var category: String
    var action: String
    var value: NSNumber
    var label: String?
    
    public init(category: String, action: String, value: NSNumber, label: String? = nil){
        self.category = category
        self.action = action
        self.value = value
        self.label = label
        
        super.init(hitType: "event", contentDescription: "")
    }
    
    override public func dictionaryRepresentationKeys() -> [String : Any?] {
        [MPEventCategoryKey:category, MPEventActionKey:action, MPEventLabelKey:label, MPEventValueKey:value]
    }
}

public class MPAppViewParams: MPTrackingRequestParams {
    public init(screen: String) {
        super.init(hitType: "screenview", contentDescription: screen)
    }
}

public class MPTimingParams: MPTrackingRequestParams {
    var category: String
    var variable: String
    var time: Int
    var label: String?
    
    public init(category: String, variable: String, time: Int, label: String? = nil) {
        self.category = category
        self.variable = variable
        self.time = time
        self.label = label
        
        super.init(hitType: "timing", contentDescription: "")
    }
    
    override public func dictionaryRepresentationKeys() -> [String : Any?] {
        [MPTimingCategoryKey:category, MPTimingVariableKey:variable, MPTimingTimeKey:time, MPTimingLabelKey:label]
    }
}

extension Dictionary {
    mutating func merge(_ dict: [Key: Value]) -> Dictionary{
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
        return self
    }
}


let MPHitTypeKey = "t";
let MPEventCategoryKey = "ec"
let MPContentDescriptionKey = "cd";

let MPEventActionKey = "ea";
let MPEventLabelKey = "el";
let MPEventValueKey = "ev";

let MPTimingCategoryKey = "utc";
let MPTimingVariableKey = "utv";
let MPTimingTimeKey = "utt";
let MPTimingLabelKey = "utl";
