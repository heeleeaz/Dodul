//
//  GlobalKeybindPreference.swift
//  Touchlet
//
//  Created by Elias on 24/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public struct GlobalKeybindPreferences: Codable, CustomStringConvertible {
    public let function : Bool
    public let control : Bool
    public let command : Bool
    public let shift : Bool
    public let option : Bool
    public let carbonFlags : UInt32
    public let characters : String?
    public let keyCode : UInt32
    
    public var description: String{return description("-")}
    
    public func description(_ seperator: String = "") -> String{
        var stringBuilder = ""
        if self.control {
            stringBuilder += "⌃\(seperator)"
        }
        if self.option {
            stringBuilder += "⌥\(seperator)"
        }
        if self.command {
            stringBuilder += "⌘\(seperator)"
        }
        if self.shift {
            stringBuilder += "⇧\(seperator)"
        }
        if let characters = self.characters {
            stringBuilder += "\(characters.uppercased())\(seperator)"
        }
        return "\(stringBuilder.dropLast(seperator.count))"
    }
    
    public init(function: Bool, control: Bool, command: Bool, shift: Bool, option: Bool, carbonFlags: UInt32, characters: String?, keyCode: UInt32) {
        self.function = function
        self.control = control
        self.command = command
        self.shift = shift
        self.option = option
        self.carbonFlags = carbonFlags
        self.characters = characters
        self.keyCode = keyCode
    }
    
    public var hasModifierFlag: Bool {function || control || command || shift || option}
    
    public static var acceptedModifiersDescription: String {"Use ⌃, ⌥, ⌘, or ⇧ with any other key, e.g ⌘E"}
}

extension GlobalKeybindPreferences{
    public static var defaultKeyBind: GlobalKeybindPreferences{
        return GlobalKeybindPreferences(function: true, control: true, command: false, shift: false, option: false, carbonFlags: 4096, characters: "1", keyCode: 18)
    }
}
