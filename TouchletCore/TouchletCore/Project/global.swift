//
//  Global.swift
//  Touchlet
//
//  Created by Elias on 10/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

#if DEBUG
public let isDebugBuild = true
#else
public let isDebugBuild = false
#endif

public class Global{
    public static var groupIdPrefix = ProjectBundleProvider.instance.projectGroupIdPrefix
}


private func setAppDelegate(application: NSApplication, delegate: NSApplicationDelegate?)-> NSApplication {
    application.delegate = delegate
    return application
}

public func runApplication<T: NSObject>(application: NSApplication = NSApplication.shared,
                                         delegateClass: T.Type? = nil,
                                         bundle: Bundle = Bundle.main,
                                         nibName: String = "MainMenu",
                                         topLevelObjects: inout NSArray?) where T: NSApplicationDelegate{
    
    let appDelegate = setAppDelegate(application: application, delegate: delegateClass?.init())
    if bundle.loadNibNamed(nibName, owner: appDelegate, topLevelObjects: &topLevelObjects) {
        application.run()
    } else {
        print("An error was encountered while starting the application.")
    }
}

public func shell(_ args: [String]) -> String {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c"]
    task.arguments? += args

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

    return output
}
