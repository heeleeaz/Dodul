//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore
import Carbon

class MainViewController: EditableTouchBarController {
    @IBOutlet weak var keybindTagView: KeybindTagView!
    @IBOutlet weak var launchTouchbarContainer: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateKeybindPresentationView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose), name: NSWindow.willCloseNotification, object: nil)
    }
    
    private func updateKeybindPresentationView(){
        if GlobalKeybindPreferencesStore.fetch() == nil{
            GlobalKeybindPreferencesStore.save(keyBind: GlobalKeybindPreferences.defaultKeyBind)

            let animation =  CABasicAnimation(keyPath: "backgroundColor")
            animation.fromValue = DarkTheme.quickObserverColor.cgColor
            animation.toValue = DarkTheme.quickLaunchPreferenceContainerBackgroundColor.cgColor
            animation.duration = 3
            launchTouchbarContainer.wantsLayer = true
            launchTouchbarContainer.layer?.add(animation, forKey: "backgroundColor")
        }
        
        keybindTagView.removeAll()
        if let keybind = GlobalKeybindPreferencesStore.fetch(){
            keybind.description.split(separator: "-").forEach{keybindTagView.addTag(String($0), isEditing: false)}
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {commitChangesAndDispatchUpdateNotification()}
    
    @objc func windowWillClose(notification: NSNotification){
        if notification.object is KeybindPreferenceWindow{
            updateKeybindPresentationView()
            DistributedNotificationCenter.default().postNotificationName(.hotKeySetup, object: Bundle.main.bundleIdentifier, userInfo: nil, options: .deliverImmediately)
        }
    }
    
    private func commitChangesAndDispatchUpdateNotification(){
        commitTouchBarEditing()
        
        DistributedNotificationCenter.default().postNotificationName(.touchItemReload, object: Bundle.main.bundleIdentifier, userInfo: nil, options: .deliverImmediately)
        
        NSApp.terminate(nil)
    }
    
    override func cancelOperation(_ sender: Any?) {
        if isTouchbarDirty{
            let alert = NSAlert()
            alert.messageText = "Save Changes?"
            alert.informativeText = "You've made some changes, they will only reflect if you save them."
            alert.alertStyle = .informational
            
            alert.addButton(withTitle: "Save")
            alert.addButton(withTitle: "Close")
            alert.beginSheetModal(for: view.window!) { ( modalResponse) in
                switch modalResponse{
                case .alertFirstButtonReturn:
                    self.commitChangesAndDispatchUpdateNotification()
                default:
                    NSApp.terminate(nil)
                }
            }
        }else{
            commitChangesAndDispatchUpdateNotification()
        }
    }
    
    override func keyDown(with event: NSEvent) {
        //default escape button
        if event.keyCode == kVK_Escape{super.keyDown(with: event)}
    }
    
    @IBAction func quickLaunchClicked(_ sender: Any) {
        KeybindPreferenceViewController.presentAsWindowKeyAndOrderFront(nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class MainWindow: NSWindow{
    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        trackScreenViewEvent(screen: self.className) //track screenView
    }
    
    override var contentView: NSView?{
        didSet{
            if let frame = NSScreen.main?.frame{
                setFrame(frame, display: true)
                setContentSize(frame.size)
            }
        }
    }
}
