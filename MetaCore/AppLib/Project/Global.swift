//
//  PreferenceUtility.swift
//  TouchletMenu
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class Global{
    public var APP_SECURITY_GROUP: String {
        Bundle.main.object(forInfoDictionaryKey: "APP_SECURITY_GROUP") as! String
    }

    public static let instance = Global()
    
    private init(){}
        
    public func bundleIdentifier(for project: Project, bundle: Bundle = Bundle.main) -> String{
        guard let identifier = Bundle.main.bundleIdentifier else { return "" }
        
        switch project {
        case .menu:
            return identifier.replacingOccurrences(of: ".Panel", with: "")
            
        case .panel:
            return identifier.replacingOccurrences(of: "Dodul", with: "Dodul.Panel")
        }
    }
    
    public func appName(for project: Project, bundle: Bundle = Bundle.main) -> String{
        guard let name = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String else{
            return ""
        }

        switch project {
        case .menu:
            return name.replacingOccurrences(of: "Panel", with: "")
            
        case .panel:
            return name.replacingOccurrences(of: "Dodul", with: "DodulPanel")
        }
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
        
        
        let path = NSString.path(withComponents: pathComponents)
        print(path)
        return NSWorkspace.shared.launchApplication(path)
    }
    
    public enum Project{
        case menu, panel
    }
}

extension Notification.Name{
    public static let hotKeySetup = NSNotification.Name("\(Global.instance.APP_SECURITY_GROUP).hotKeySetup")
    public static let touchItemReload = Notification.Name("\(Global.instance.APP_SECURITY_GROUP).refreshTouchItem")
    public static let killApp = NSNotification.Name("\(Global.instance.APP_SECURITY_GROUP).killApp")
}
