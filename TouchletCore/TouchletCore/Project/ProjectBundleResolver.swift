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
    
    public func bundlePath(for project: Project) -> URL{
        var pathComponents = URL(fileURLWithPath: Bundle.main.bundlePath).pathComponents

        switch project {
        case .updateService:
            pathComponents.append("Contents")
            pathComponents.append("Library")
            pathComponents.append("App")
            pathComponents.append("UpdateService.app")
        case .panel:
            pathComponents.append("Contents")
            pathComponents.append("Library")
            pathComponents.append("App")
            pathComponents.append("TouchletPanel.app")
        case .panelLauncher:
            pathComponents.append("Contents")
            pathComponents.append("Library")
            pathComponents.append("App")
            pathComponents.append("LaunchHelper.app")
        default: break
        }
        
        return URL(fileURLWithPath: NSString.path(withComponents: pathComponents))
    }
    
    public func isRunning(project: Project) -> Bool{
        NSWorkspace.shared.runningApplications.contains{$0.bundleURL == bundlePath(for: project)}
    }
    
    public func launch(project: Project) throws {
        if !isRunning(project: project){
            try NSWorkspace.shared.launchApplication(at: bundlePath(for: project), options: .default, configuration: [:])
        }
    }
    
    public enum Project{
        case main, updateService, panel, panelLauncher
    }
    
    public func terminateAppWithAllSubProject(){
        NSApp.terminate(nil)
    }
}

