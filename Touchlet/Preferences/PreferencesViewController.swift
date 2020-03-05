//
//  PreferencesViewController.swift
//  Touchlet
//
//  Created by Elias on 24/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import HotKey
import Carbon
import Core

class PreferencesViewController: NSViewController, NibLoadable {
    @IBOutlet weak var stackView: KeybindTagView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        respondNonEditingKeybindPreferenceWithUI()
    }

    fileprivate func updateGlobalShortcut(_ event : NSEvent) {
        guard let characters = event.charactersIgnoringModifiers else {return}
        var modifierFlags = event.modifierFlags
        
        if modifierFlags.carbonFlags == 0{modifierFlags = NSEvent.ModifierFlags.command}
    
        let newGlobalKeybind = GlobalKeybindPreferences(
            function: modifierFlags.contains(.function),
            control: modifierFlags.contains(.control),
            command: modifierFlags.contains(.command),
            shift: modifierFlags.contains(.shift),
            option: modifierFlags.contains(.option),
            capsLock: modifierFlags.contains(.capsLock),
            carbonFlags: modifierFlags.carbonFlags,
            characters: characters, keyCode: UInt32(event.keyCode)
        )
        respondEditingKeybindPreferenceWithUI(keybind: newGlobalKeybind)
            
        saveButton.addClickGestureRecognizer{
            GlobalKeybindPreferencesStore.save(keyBind: newGlobalKeybind) // save it
            
            let ad = NSApplication.shared.delegate as! AppDelegate
            ad.hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: UInt32(event.keyCode), carbonModifiers: event.modifierFlags.carbonFlags))
            self.view.window?.close()
        }
    }
    
    private func respondNonEditingKeybindPreferenceWithUI(){
        if let keybind = GlobalKeybindPreferencesStore.fetch(){
            saveButton.isEnabled = false
            
            cancelButton.title = "Cancel"
            updateKeybindPresentationView(keybind, editing: false)
        }
    }
    
    private func respondEditingKeybindPreferenceWithUI(keybind: GlobalKeybindPreferences){
        saveButton.isEnabled = true
        
        cancelButton.isEnabled = true
        cancelButton.title = "Reset"
        updateKeybindPresentationView(keybind, editing: true)
    }
    
    @IBAction func cancelClick(_ sender: NSButton) {
        if sender.title.elementsEqual("Reset"){respondNonEditingKeybindPreferenceWithUI()}
        else{self.view.window?.close()}
    }
    
    private func updateKeybindPresentationView(_ keybind : GlobalKeybindPreferences, editing: Bool){
        stackView.removeAllTags()
        for s in keybind.description.split(separator: "-"){
            stackView.addTagItem(String(s), isEditing: editing)
        }
    }
}

class PreferencesWindowController: NSWindowController{
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.makeFirstResponder(self)
    }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        if let controller = self.contentViewController as? PreferencesViewController {
            controller.updateGlobalShortcut(event)
        }
        
        self.interpretKeyEvents([event])
    }
    
    override func cancelOperation(_ sender: Any?) {self.close()}
}
