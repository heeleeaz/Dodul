//
//  ViewController.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSTouchBarDelegate {
    @IBOutlet weak var displayInstructionLabel: NSTextField!
    @IBOutlet weak var doneButton: NSButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.addClickGestureRecognizer{ terminateApp(self) }
        displayInstructionLabel.addClickGestureRecognizer{
            
            
            if let vc = PreferencesViewController.createFromNib(){
//                self.present(vc, asPopoverRelativeTo: NSRect.zero, of: self.displayInstructionLabel, preferredEdge: .maxX, behavior: .applicationDefined)
                self.presentAsModalWindow(vc)
                vc.becomeFirstResponder()
                
//                self.preset
            }
            
            
        }
        setupDisplayInstructionText()
    }
    
    override func cancelOperation(_ sender: Any?) {
        terminateApp(self)
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        print("left mouse")
    }

    override func rightMouseDown(with theEvent: NSEvent) {
        print("right mouse")
    }
    
    private func setupDisplayInstructionText(){
        guard let cache = (try? Cache<String, GlobalKeybindPreferences>.loadFromDisk(withName: HotKeyStore.Constant.KEYCODE_CACHE_KEY)), let key = cache.value(forKey: HotKeyStore.Constant.KEYCODE_CACHE_KEY) else {return}
        
        let hotKey = " \(key.description(" - ")) "
        let mainString = "Press \(hotKey) to display Touchbar anytime. Tap to edit"
        let attribute = NSMutableAttributedString(string: mainString)
        
        attribute.addAttributes([
            .foregroundColor: NSColor.hotKeyAttributeTextForegroundColor,
            .backgroundColor: NSColor.hotKeyAttributeTextBackgroundColor],
            range: (mainString as NSString).range(of: hotKey))
        
        displayInstructionLabel.attributedStringValue = attribute
    }
}
