//
//  InstructionBarVC.swift
//  Meta
//
//  Created by Elias on 06/05/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import MetaCore
import Carbon

class MenuPanelViewController: NSViewController, NibLoadable{
    @IBOutlet weak var hotKeyComboView: HotkeyComboView!
    
    private lazy var editableTouchBarController: EditableTouchBarController = {
        guard let controller = self.parent as? EditableTouchBarController else {
            fatalError("parent must be an instance of EditableTouchBarItem")
        }
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateKeybindPresentationView()
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose), name: NSWindow.willCloseNotification, object: nil)
    }
    
    private func updateKeybindPresentationView(){
        if GlobalKeybindPreferencesStore.fetch() == nil{
            GlobalKeybindPreferencesStore.save(keyBind: GlobalKeybindPreferences.defaultKeyBind)
        }
        
        hotKeyComboView.clearView()
        if let keybind = GlobalKeybindPreferencesStore.fetch(){
            keybind.toArray.forEach{hotKeyComboView.addKey($0.first!, isEditing: false)}
        }
    }
    
    @objc func windowWillClose(notification: NSNotification){
        if notification.object is HotkeyPreferenceWindow{
            updateKeybindPresentationView()
            DistributedNotificationCenter.default().postNotificationName(.hotKeySetup, object: nil, userInfo: nil, options: .deliverImmediately)
        }
    }
    
    @IBAction func changeHotkeyTapped(_ sender: Any) {
        HotkeyPrefsViewController.presentAsWindowKeyAndOrderFront(nil)
    }
    
    override func keyDown(with event: NSEvent) {if event.keyCode == kVK_Escape{super.keyDown(with: event)}}
}
