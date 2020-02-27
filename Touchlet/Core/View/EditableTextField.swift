//
//  EditableTextField.swift
//  Touchlet
//
//  Created by Elias on 26/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class EditingTextField: NSTextField {
    private let commandKey = NSEvent.ModifierFlags.command.rawValue
    private let commandShiftKey = NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == NSEvent.EventType.keyDown {
            if (event.modifierFlags.rawValue &
                NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
            switch event.charactersIgnoringModifiers! {
            case "x":
                if NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self) { return true }
            case "c":
                if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return true }
            case "v":
                if NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self) { return true }
            case "z":
                if NSApp.sendAction(Selector(("undo:")), to:nil, from:self) { return true }
            case "a":
                if NSApp.sendAction(#selector(NSText.selectAll(_:)), to:nil, from:self) { return true }
            default:
              break
            }
          } else if (event.modifierFlags.rawValue &
                NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandShiftKey {
            if event.charactersIgnoringModifiers == "Z" {
                if NSApp.sendAction(Selector(("redo:")), to:nil, from:self) { return true }
            }
          }
        }
        return super.performKeyEquivalent(with: event)
    }
}

class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    override func drawingRect(forBounds theRect: NSRect) -> NSRect {
        let newRect = NSRect(x: 0, y: (theRect.size.height - 22) / 2, width: theRect.size.width, height: 22)
        return super.drawingRect(forBounds: newRect)
    }
}
