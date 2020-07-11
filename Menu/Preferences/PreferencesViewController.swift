//
//  PreferencesViewController.swift
//  TouchletMenu
//
//  Created by Elias on 20/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import Carbon
import AppLib

class AboutPreferenceViewController: NSViewController{
    @IBOutlet weak var appNameLabel: NSTextField!
    @IBOutlet weak var appVersionLabel: NSTextField!
    @IBOutlet weak var copyrightLabel: NSTextField!
    @IBOutlet weak var updateViewContainer: NSView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoDictionary = Bundle.main.infoDictionary!
        
        appVersionLabel.stringValue = "Version \((infoDictionary["CFBundleShortVersionString"] as? String) ?? "")"
        appNameLabel.stringValue = infoDictionary["CFBundleName"] as? String ?? ""
        copyrightLabel.stringValue = infoDictionary["NSHumanReadableCopyright"] as? String ?? ""
        
        //add update controller view
        addChildHelper(AppUpdateController(), view: updateViewContainer)
    }
    
    override func keyDown(with event: NSEvent) {if event.keyCode == kVK_Escape{super.keyDown(with: event)}}
    
    override func cancelOperation(_ sender: Any?) {view.window?.close()}
}
