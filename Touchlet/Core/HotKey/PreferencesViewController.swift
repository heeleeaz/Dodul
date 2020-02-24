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

class PreferencesViewController: NSViewController, NibLoadable {
    @IBOutlet weak var clearButton: NSButton!
    @IBOutlet weak var shortcutButton: NSButton!
    
    var listening = false {
        didSet {
            if listening {
                DispatchQueue.main.async { [weak self] in self?.shortcutButton.highlight(true)}
            } else {
                DispatchQueue.main.async { [weak self] in self?.shortcutButton.highlight(false)}
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let key = Cache<String, GlobalKeybindPreferences>().value(forKey: "HotKey"){
            updateKeybindButton(key)
            updateClearButton(key)
        }
    }

    func updateGlobalShortcut(_ event : NSEvent) {
        self.listening = false

        guard let characters = event.charactersIgnoringModifiers else {return}
        
        let newGlobalKeybind = GlobalKeybindPreferences(
            function: event.modifierFlags.contains(.function),
            control: event.modifierFlags.contains(.control),
            command: event.modifierFlags.contains(.command),
            shift: event.modifierFlags.contains(.shift),
            option: event.modifierFlags.contains(.option),
            capsLock: event.modifierFlags.contains(.capsLock),
            carbonFlags: event.modifierFlags.carbonFlags,
            characters: characters,
            keyCode: UInt32(event.keyCode)
        )
        
        do{
            let cache = Cache<String, GlobalKeybindPreferences>()
            cache.insert(newGlobalKeybind, forKey: "HotKey")
            try cache.saveToDisk(withName: "HotKey")
            
            updateKeybindButton(newGlobalKeybind)
            clearButton.isEnabled = true
            let appDelegate = NSApplication.shared.delegate as! AppDelegate
            appDelegate.hotKey = HotKey(keyCombo: KeyCombo(carbonKeyCode: UInt32(event.keyCode), carbonModifiers: event.modifierFlags.carbonFlags))
        }catch{
        }
    }

    @IBAction func register(_ sender: Any) {
        unregister(nil)
        listening = true
        view.window?.makeFirstResponder(nil)
    }

    @IBAction func unregister(_ sender: Any?) {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hotKey = nil
        shortcutButton.title = ""
        
        do{
            let cache = Cache<String, GlobalKeybindPreferences>()
            cache.removeValue(forKey: "HotKey"); try cache.saveToDisk(withName: "HotKey")
        }catch{
        }
    }

    func updateClearButton(_ globalKeybindPreference : GlobalKeybindPreferences?) {
        if globalKeybindPreference != nil {clearButton.isEnabled = true}
        else {clearButton.isEnabled = false}
    }

    func updateKeybindButton(_ globalKeybindPreference : GlobalKeybindPreferences) {
        shortcutButton.title = globalKeybindPreference.description
    }
}
