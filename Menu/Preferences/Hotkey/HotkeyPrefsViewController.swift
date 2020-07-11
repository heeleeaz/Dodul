//
//  HotkeyPrefsViewController.swift
//  Meta
//
//  Created by Elias on 24/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import Carbon
import AppLib

class HotkeyPrefsViewController: NSViewController, NibLoadable {
    
    @IBOutlet weak var hotKeyComboView: HotkeyComboView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var tipLabelTextView: NSTextField!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let acceptedModifiers = GlobalKeybindPreferences.acceptedModifiers.joined(separator: ", ")
        tipLabelTextView.stringValue = "Use either \(acceptedModifiers) with any other character. e.g ⌘E"
        
        cancelButton.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(cancelClick)))
        setupHotkeyComboViewData()
    }
    
    private func setupHotkeyComboViewData(){
        if let globalKeyBindPreferences = GlobalKeybindPreferencesStore.fetch(){
            saveButton.isEnabled = false
            cancelButton.title = "Cancel"
            
            hotKeyComboView.clearView()
            globalKeyBindPreferences.toArray.forEach{hotKeyComboView.addKey($0.first!, isEditing: true)}
        }
    }
    
    private func handleKeyEventForHotkey(_ event: NSEvent) -> Bool{
        if UInt32(event.keyCode) == 49 {return false}
        
        let character = event.type == .flagsChanged ? "" : event.charactersIgnoringModifiers
        
        let globalKeyBindPreferences = GlobalKeybindPreferences(
            control: event.modifierFlags.contains(.control),
            command: event.modifierFlags.contains(.command),
            shift: event.modifierFlags.contains(.shift),
            option: event.modifierFlags.contains(.option),
            carbonFlags: event.modifierFlags.carbonFlags,
            characters: character, keyCode: UInt32(event.keyCode))
        
        if globalKeyBindPreferences.hasModifierFlag {
            hotKeyComboView.clearView()
            
            let keys = globalKeyBindPreferences.toArray
            for i in 0..<keys.count - 1{
                hotKeyComboView.addKey(keys[i].first!, isEditing: false)
            }
            
            if let char = keys.last, char != ""{
                hotKeyComboView.addKey(char.first!, isEditing: false)
            }else{
                //make the current character has hint
                let curChar = GlobalKeybindPreferencesStore.fetch()?.characters ?? " "
                hotKeyComboView.addKey(curChar.first!, isEditing: true)
            }
            
            saveButton.addClickGestureRecognizer{
                GlobalKeybindPreferencesStore.save(keyBind: globalKeyBindPreferences)
                self.view.window?.close()
            }
            
            saveButton.isEnabled = true
            cancelButton.isEnabled = true
            cancelButton.title = "Reset"
            
            return true
        }else{
            return false
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == kVK_Escape{
            view.window?.close()
        }else if !handleKeyEventForHotkey(event){
            super.keyDown(with: event)
        }
    }
    
    override func flagsChanged(with event: NSEvent) {
        if !handleKeyEventForHotkey(event){
            super.flagsChanged(with: event)
        }
    }
        
    @objc private func cancelClick() {
        if cancelButton.title.elementsEqual("Reset"){setupHotkeyComboViewData()}
        else{self.view.window?.close()}
    }
}

extension HotkeyPrefsViewController{
    public static func presentAsWindowKeyAndOrderFront(_ sender: Any?){
        let window = HotkeyPreferenceWindow(contentViewController: createFromNib()!)
        
        if let screenSize = NSScreen.main?.frame.size{
            window.setFrameOrigin(NSPoint.center(a: screenSize, b: window.frame.size))
        }
        
        window.makeKeyAndOrderFront(sender)
    }
}
