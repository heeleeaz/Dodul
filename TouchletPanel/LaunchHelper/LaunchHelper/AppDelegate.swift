//
//  AppDelegate.swift
//  LaunchHelper
//
//  Created by Elias on 09/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //check if the Main application is running
        let startedAtLogin = NSWorkspace.shared.runningApplications.contains{$0.bundleIdentifier == Constants.mainBundleIdentifier}
        if startedAtLogin {
            killApp() // true, main app was launched at login, terminate helper app
        }else{
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(killApp), name: Constants.KILLAPP, object: Constants.mainBundleIdentifier)
            launchMainApplication()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    @objc func killApp(){
        NSApp.terminate(nil)
    }
    
    private func launchMainApplication(){
        NSWorkspace.shared.launchApplication(Constants.mainBundleIdentifier)
    }
}

extension AppDelegate{
    struct Constants {
        static let KILLAPP = NSNotification.Name("KILLAPP")
        static let mainBundleIdentifier = "com.heeleeaz.touchlet.panel"
    }
}

