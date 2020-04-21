//
//  PreferencesViewController.swift
//  Touchlet
//
//  Created by Elias on 24/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit
import Carbon
import MetaCore

class KeybindPreferenceViewController: NSViewController, NibLoadable {
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
        stackView.removeAll()
        for s in keybind.description.split(separator: "-"){
            stackView.addTag(String(s), isEditing: editing)
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

extension KeybindPreferenceViewController{
    public static func presentAsWindowKeyAndOrderFront(_ sender: Any?){
        let window = KeybindPreferenceWindow(contentViewController: createFromNib()!)
        
        if let screenSize = NSScreen.main?.frame.size{
            window.setFrameOrigin(NSPoint.center(a: screenSize, b: window.frame.size))
        }
        
        window.makeKeyAndOrderFront(sender)
    }
}

public class KeybindPreferenceWindow: NSWindow{
    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        postInit()
        
        trackScreenViewEvent(screen: self.className) //track screenView
    }
    
    public func postInit(){
        backgroundColor = DarkTheme.touchBarButtonBackgroundColor
        
        styleMask.remove([.resizable])
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }
}
