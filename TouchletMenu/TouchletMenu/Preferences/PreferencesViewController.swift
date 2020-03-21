//
//  PreferencesViewController.swift
//  TouchletMenu
//
//  Created by Elias on 20/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import Carbon

class AboutPreferenceViewController: NSViewController{
    @IBOutlet weak var appNameLabel: NSTextField!
    @IBOutlet weak var appVersionLabel: NSTextField!
    @IBOutlet weak var copyrightLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoDictionary = Bundle.main.infoDictionary!
        
        appVersionLabel.stringValue = "Version \((infoDictionary["CFBundleShortVersionString"] as? String) ?? "")"
        appNameLabel.stringValue = infoDictionary["CFBundleName"] as? String ?? ""
        copyrightLabel.stringValue = infoDictionary["NSHumanReadableCopyright"] as? String ?? ""
    }
    
    override func keyDown(with event: NSEvent) {if event.keyCode == kVK_Escape{super.keyDown(with: event)}}
    
    override func cancelOperation(_ sender: Any?) {view.window?.close()}
}


public class PreferencesWindow: NSWindow{
    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        postInit()
    }
    
    public func postInit(){
        styleMask.remove([.resizable])
        standardWindowButton(.zoomButton)?.isEnabled = false
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        backgroundColor = DarkTheme.touchBarButtonBackgroundColor
    }
}
