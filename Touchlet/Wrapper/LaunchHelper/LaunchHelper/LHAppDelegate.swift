//
//  AppDelegate.swift
//  LaunchHelper
//
//  Created by Elias on 09/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

@NSApplicationMain
class LHAppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //check if the Main application is running
        let manAppIdentifier = ProjectBundleResolver.instance.bundleIdentifier(for: .main)
        let mainRunning = NSWorkspace.shared.runningApplications.contains{$0.bundleIdentifier == manAppIdentifier}
        if mainRunning {
            // true, main app was launched at login, terminate helper app
            killApp()
        }else{
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(killApp), name: .killApp, object: manAppIdentifier)
            launchMainApplication()
        }
    }
    
    private func launchMainApplication(){
        let identifier = ProjectBundleResolver.instance.bundleIdentifier(for: .main)
        NSWorkspace.shared.launchApplication(withBundleIdentifier: identifier, options: .default, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    }
    
    @objc func killApp(){NSApp.terminate(nil)}
}
