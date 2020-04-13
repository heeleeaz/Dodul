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
        //check if the Main applic¡ation is running
        let panelIdentifier = ProjectBundleProvider.instance.bundleIdentifier(for: .panel)
        if (NSWorkspace.shared.runningApplications.contains{$0.bundleIdentifier == panelIdentifier}) {
            // true, panel app was launched at login, terminate helper app
            killApp()
        }else{
            DistributedNotificationCenter.default().addObserver(self, selector: #selector(killApp), name: .killApp, object: panelIdentifier)
            NSWorkspace.shared.launchApplication(ProjectBundleProvider.instance.appName(for: .panel))
        }
    }
    
    @objc func killApp(){NSApp.terminate(nil)}
}
