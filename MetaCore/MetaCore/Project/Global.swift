//
//  PreferenceUtility.swift
//  TouchletMenu
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class Global{
    public var APP_SECURITY_GROUP: String{Bundle.main.object(forInfoDictionaryKey: "APP_SECURITY_GROUP") as! String}

    public static let shared = Global()
    
    private init(){}
        
    public func bundleIdentifier(for project: Project) -> String{
        switch project {
        case .meta:
            return "com.heeleeaz.Meta\(environmentSuffixString("."))"
        case .panel:
            return "com.heeleeaz.MetaPanel\(environmentSuffixString("."))"
        }
    }
    
    public func appName(for project: Project) -> String{
        switch project {
        case .meta:
            return "Meta\(environmentSuffixString("-"))"
        case .panel:
            return "MetaPanel\(environmentSuffixString("-"))"
        }
    }
    
    public func environmentSuffixString(_ seperator: String) -> String {
        #if DEBUG
            return "\(seperator)debug"
        #elseif ALPHA
            return "\(seperator)alpha"
        #else
            return ""
        #endif
    }
    
    @discardableResult
    public func launch(removeLast: Int, append: [String], bundlePath: String = Bundle.main.bundlePath) -> Bool{
        if (NSWorkspace.shared.runningApplications.contains{$0.bundleURL?.absoluteString == bundlePath}){
            Logger.log(text: "\(bundlePath) is already running: true")
            return true
        }
        
        var pathComponents = (bundlePath as NSString).pathComponents
        if removeLast > 0{pathComponents.removeLast(removeLast)}
        append.forEach{pathComponents.append($0)}
        
        return NSWorkspace.shared.launchApplication(NSString.path(withComponents: pathComponents))
    }
    
    public enum Project{
        case meta, panel
    }
}

extension Notification.Name{
    public static let hotKeySetup = NSNotification.Name("HOTKEY_SETUP")
    public static let touchItemReload = Notification.Name("refreshTouchItem")
    public static let killApp = NSNotification.Name("KILLAPP")
}
