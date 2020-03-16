//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

class MainWindow: NSWindow{
    override var contentView: NSView?{
        didSet{
            if let frame = NSScreen.main?.frame{
                setFrame(frame, display: true)
                setContentSize(frame.size)
            }
        }
    }
}

class MainWindowViewController: NSWindowController{
}

class MainViewController: EditableTouchBarController {
    @IBOutlet weak var keybindTagView: KeybindTagView!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateKeybindPresentationView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClosedNotification), name: NSWindow.willCloseNotification, object: nil)
    }
    
    @objc func windowWillClosedNotification(notification: NSNotification){
        if notification.object is PreferencesWindow{updateKeybindPresentationView()}
    }
    
    private func updateKeybindPresentationView(){
        keybindTagView.removeAllTags()
        if let keybind = GlobalKeybindPreferencesStore.fetch(){
            for s in keybind.description.split(separator: "-"){
                keybindTagView.addTagItem(String(s), isEditing: false)
            }
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        commitTouchBarEditing()
        
        DistributedNotificationCenter.default().postNotificationName(.touchItemReload, object: Bundle.main.bundleIdentifier, userInfo: nil, options: .deliverImmediately)
        
        DistributedNotificationCenter.default().postNotificationName(.hotKeySetup, object: Bundle.main.bundleIdentifier, userInfo: nil, options: .deliverImmediately)
        terminateApp(self)
    }
    
    override func cancelOperation(_ sender: Any?) {terminateApp(self)}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func keyDown(with event: NSEvent) {
        //default escape button
        if event.keyCode == 53{
            super.keyDown(with: event)
        }
    }
}
