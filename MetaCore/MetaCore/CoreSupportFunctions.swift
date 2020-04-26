//
//  AnalyticsHelper.swift
//  TouchletCore
//
//  Created by Elias on 18/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public func trackItemClickEvent(label: String, identifier: String, tracker: MPGoogleAnalyticsTracker = .shared) {
    tracker.trackEvent(with: MPEventParams(category: "itemClickEvent", action: identifier, value: 1, label: label))
}

public func trackItemAddEvent(label: String, identifier: String, tracker: MPGoogleAnalyticsTracker = .shared){
    tracker.trackEvent(with: MPEventParams(category: "itemAddEvent", action: identifier, value: 1, label: label))
}

public func trackItemRemoveEvent(label: String, identifier: String, tracker: MPGoogleAnalyticsTracker = .shared){
    tracker.trackEvent(with: MPEventParams(category: "itemRemoveEvent", action: identifier, value: 1, label: label))
}

public func trackScreenViewEvent(screen: String, tracker: MPGoogleAnalyticsTracker = .shared){
    tracker.trackScreen(with: MPAppViewParams(screen: screen))
}


public let kCSFWebLink = "webLink"
public let kCSFApp = "app"
public let kCSFUnspecified = "unspecified"
