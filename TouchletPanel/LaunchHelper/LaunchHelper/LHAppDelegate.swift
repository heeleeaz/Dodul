//
//  AppDelegate.swift
//  LaunchHelper
//
//  Created by Elias on 09/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class LHAppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //check if the Main application is running
        let mainRunning = NSWorkspace.shared.runningApplications.contains{$0.bundleIdentifier == Constants.mainBundleIdentifier}
        if mainRunning {
            // true, main app was launched at login, terminate helper app
            killApp()
        }else{
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(killApp), name: Constants.KILLAPP, object: Constants.mainBundleIdentifier)
            launchMainApplication()
        }
    }
    
    private func launchMainApplication(){
        var pathComponents = URL(fileURLWithPath: Bundle.main.bundlePath).pathComponents
        pathComponents.removeLast(4)
        
        NSWorkspace.shared.launchApplication(NSString.path(withComponents: pathComponents))
    }
    
    @objc func killApp(){NSApp.terminate(nil)}
}

extension LHAppDelegate{
    struct Constants {
        static let KILLAPP = NSNotification.Name("KILLAPP")
        static let mainBundleIdentifier = "com.heeleeaz.touchlet.TouchletPanel"
    }
}
