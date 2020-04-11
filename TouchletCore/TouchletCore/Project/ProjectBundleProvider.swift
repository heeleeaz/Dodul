//
//  PreferenceUtility.swift
//  TouchletMenu
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class ProjectBundleProvider{
    public static let instance = ProjectBundleProvider()
    
    private init(){}
    
    public let projectGroupIdPrefix = "group.com.heeleeaz.touchlet"
    
    public func bundleIdentifier(for project: Project) -> String{
        switch project {
        case .main:
            return "com.heeleeaz.touchlet.Touchlet"
        case .panel:
            return "com.heeleeaz.touchlet.TouchletPanel"
        case .panelLauncher:
            return "com.heeleeaz.touchlet.LaunchHelper"
        case .updateService:
            return "com.heeleeaz.touchlet.UpdateService"
        case .core:
            return "com.heeleeaz.touchlet.TouchletCore"
        }
    }
    
    public func appName(for project: Project) -> String{
        switch project {
        case .main:
            return "Touchlet"
        case .panel:
            return "TouchletPanel"
        case .updateService:
            return "UpdateService"
        case .panelLauncher:
            return "LaunchHelper"
        case .core:
            return "TouchletCore"
        }
    }
        
    public func terminateAppWithAllSubProject(){NSApp.terminate(nil)}
    
    @discardableResult
    public func launchApplication(project: Project, launchOptions: NSWorkspace.LaunchOptions) -> Bool{
        let identifier = ProjectBundleProvider.instance.bundleIdentifier(for: project)
        if (NSWorkspace.shared.runningApplications.contains{$0.bundleIdentifier == identifier}){
            Logger.log(text: "\(identifier) is already running: true")
            return true
        }
        
        let launchSuccessful = NSWorkspace.shared.launchApplication(withBundleIdentifier: identifier,
                                                                options: launchOptions,
                                                                additionalEventParamDescriptor: nil,
                                                                launchIdentifier: nil)
        Logger.log(text: "launching \(identifier): \(launchSuccessful)")
        
        return true
    }
    
    public enum Project{case main, updateService, panel, panelLauncher, core}
}

