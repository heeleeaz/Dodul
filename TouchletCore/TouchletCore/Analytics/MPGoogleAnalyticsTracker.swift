//
//  Analytics.swift
//  TouchletCore
//
//  Created by Elias on 16/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class MPGoogleAnalyticsTracker {
    private var activeConfiguration: MPAnalyticsConfiguration?
    private var session: URLSession?
    
    public static let shared = MPGoogleAnalyticsTracker()
        
    private init(){
        let config = URLSessionConfiguration.ephemeral
        config.httpAdditionalHeaders = ["User-Agent": userAgentString]
        config.httpMaximumConnectionsPerHost = 1
        session = URLSession(configuration: config)
    }
    
    public func activate(configuration: MPAnalyticsConfiguration) {
        self.activeConfiguration = configuration
    }
    
    var isBeta: Bool{
        let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        return (version?.lowercased() as NSString?)?.range(of: "b").location == NSNotFound
    }
    
    var isDebug: Bool{
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    lazy var applicationName: String = {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? "Unresolved AppName"
    }()
    
    lazy var applicationVersion: String = {
        var versionString = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "Unknown"
        #if DEBUG
            versionString += "-debug"
        #endif
        
        return versionString
    }()
    
    lazy var userIdentifier: String = {
        // Get the platform expert
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))

        // Get the serial number as a CFString ( actually as Unmanaged<AnyObject>! )
        let serialNimber = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0);

        // Release the platform expert (we're responsible)
        IOObjectRelease(platformExpert);

        // Take the unretained value of the unmanaged-any-object
        // (so we're not responsible for releasing it)
        // and pass it back as a String or, if it fails, an empty string
        return (serialNimber?.takeUnretainedValue() as? String) ?? ""
    }()
    
    lazy var userAgentString: String = {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        return "Macintosh; Intel Mac OS X \(osVersion.majorVersion)_\(osVersion.minorVersion)_\(osVersion.patchVersion)"
    }()
    
    lazy var prefferedLanguage = NSLocale.preferredLanguages[0]
    
    lazy var screenSizeString: String = {
        return String(format: "%dx%d", NSScreen.main?.frame.width ?? 0, NSScreen.main?.frame.height ?? 0)
    }()
    
    private func filteredDictionary(for parameters: MPTrackingRequestParams?) -> [AnyHashable : Any]? {
        return parameters?.dictionaryRepresentation()
    }
    
    private func requestString(for requestDictionary: [AnyHashable : Any]?, gaid identifier: String) -> String? {
        var result = "v=1&tid=\(identifier)&an=\(applicationName)&av=\(applicationVersion)&cid=\(userIdentifier)"
        for (key, value) in requestDictionary ?? [:] {
            guard let key = key as? String else {
                fatalError("key must be type of String")
            }
            
            let escapedValue = (value as? String)?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            result += "&\(key)=\(escapedValue ?? "")"
        }
        result += "&sr=\(screenSizeString)&ul=\(prefferedLanguage)"
        return result
    }
    
    private func sendAnalytics(with parameters: [AnyHashable : Any]?, trackingEvent: MPTrackingRequestParams?) {
        guard let configuration = activeConfiguration else {return}

        var eventCategory: String? = nil
        if (trackingEvent is MPEventParams) {
            eventCategory = (trackingEvent as? MPEventParams)?.category
        }

        let duplicateEvent = eventCategory != nil && configuration.duplicateIdentifiers[eventCategory ?? ""] != nil
        var allIdentifiers: [AnyHashable?]
        
        if duplicateEvent{
            allIdentifiers = [configuration.analyticsIdentifier,
                              configuration.duplicateIdentifiers[eventCategory ?? ""]].compactMap{$0}
        }else{
            allIdentifiers = [configuration.analyticsIdentifier ?? ""].compactMap{$0}
        }
        
        guard let analyticsURL = URL(string: "https://www.google-analytics.com/collect") else {return}
        for identifier in allIdentifiers {
            guard let identifier = identifier as? String else {continue}
            
            var request = URLRequest(url: analyticsURL)
            request.httpBody = requestString(for: parameters, gaid: identifier)?.data(using: .utf8)
            request.httpMethod = "POST"
                        
            session?.dataTask(with: request).resume()
            
            if isDebug{Logger.log(text: "Google sendAnalytics event: \(identifier) \(parameters ?? [:])")}
        }
    }
    
    public func trackEvent(with params: MPEventParams?) {sendAnalytics(with: filteredDictionary(for: params), trackingEvent: params)}

    public func trackTiming(with params: MPTimingParams?) {sendAnalytics(with: filteredDictionary(for: params), trackingEvent: params)}
    
    public func trackScreen(with params: MPAppViewParams?){sendAnalytics(with: filteredDictionary(for: params), trackingEvent: params)}
}
