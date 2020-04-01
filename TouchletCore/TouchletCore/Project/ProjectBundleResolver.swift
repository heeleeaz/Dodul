//
//  PreferenceUtility.swift
//  TouchletMenu
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class ProjectBundleResolver{
    public static let instance = ProjectBundleResolver()
    
    private init(){}
    
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
        }
    }
    
    public func appName(for project: Project) -> String{
        switch project {
        case .main:
            return "Touchlet"
        case .panel:
            return "TouchletPanel"
        default:
            return ""
        }
    }
    
    public func appURL(for project: Project) -> String{
        switch project {
        case .main:
            return "Touchlet"
        default:
            return ""
        }
    }
    
    public let projectGroupIdPrefix = "group.com.heeleeaz.touchlet"

    public enum Project{
        case main, updateService, panel, panelLauncher
    }
    
    public func terminateAppWithAllSubProject(){
        NSApp.terminate(nil)
    }
}

