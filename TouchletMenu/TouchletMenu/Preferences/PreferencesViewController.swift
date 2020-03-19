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
import TouchletCore

class PreferencesViewController: NSViewController, NibLoadable {
    @IBOutlet weak var stackView: KeybindTagView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var tipLabelTextView: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        respondNonEditingKeybindPreferenceWithUI()
        
        tipLabelTextView.stringValue = GlobalKeybindPreferences.acceptedModifiersDescription
        cancelButton.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(cancelClick)))
    }

    @discardableResult fileprivate func updateGlobalShortcut(_ event : NSEvent) -> Bool {
        guard let characters = event.charactersIgnoringModifiers else {return false}
    
        let newGlobalKeybind = GlobalKeybindPreferences(
            function: event.modifierFlags.contains(.function),
            control: event.modifierFlags.contains(.control),
            command: event.modifierFlags.contains(.command),
            shift: event.modifierFlags.contains(.shift),
            option: event.modifierFlags.contains(.option),
            carbonFlags: event.modifierFlags.carbonFlags,
            characters: characters, keyCode: UInt32(event.keyCode)
        )
        
        if newGlobalKeybind.hasModifierFlag{
            respondEditingKeybindPreferenceWithUI(keybind: newGlobalKeybind)
            saveButton.addClickGestureRecognizer{
                GlobalKeybindPreferencesStore.save(keyBind: newGlobalKeybind)
                self.view.window?.close()
            }
            return true
        }
        
        return false
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
    
    private func updateKeybindPresentationView(_ keybind : GlobalKeybindPreferences, editing: Bool){
        stackView.removeAllTags()
        for s in keybind.description.split(separator: "-"){
            stackView.addTagItem(String(s), isEditing: editing)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        print(event)
        if event.keyCode == kVK_Escape{
            interpretKeyEvents([event])
        }else{
            self.updateGlobalShortcut(event)
        }
    }
    
    override func cancelOperation(_ sender: Any?) {view.window?.close()}
    
    @objc private func cancelClick() {
        if cancelButton.title.elementsEqual("Reset"){respondNonEditingKeybindPreferenceWithUI()}
        else{self.view.window?.close()}
    }
}

extension PreferencesViewController{
    public static func presentAsWindowKeyAndOrderFront(_ sender: Any?){
        if let controller = PreferencesViewController.createFromNib(){
            let window = PreferencesWindow(contentViewController: controller)
            
            if let screenSize = NSScreen.main?.frame.size{
                window.setFrameOrigin(NSPoint.center(a: screenSize, b: window.frame.size))
            }
            
            window.makeKeyAndOrderFront(sender)
        }
    }
}

public class PreferencesWindow: NSWindow{
    public override var backgroundColor: NSColor!{set{}get{Theme.touchBarButtonBackgroundColor}}
    
    public override func standardWindowButton(_ b: NSWindow.ButtonType) -> NSButton? {
        let button = super.standardWindowButton(b)
        button?.isHidden = true
        return button
    }
    
    public override var titleVisibility: NSWindow.TitleVisibility{get{return .hidden} set{}}
    
    public override var titlebarAppearsTransparent: Bool{get{return true} set{}}
}
