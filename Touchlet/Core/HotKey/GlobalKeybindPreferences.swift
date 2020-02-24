//
//  GlobalKeybindPreference.swift
//  Touchlet
//
//  Created by Elias on 24/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import HotKey

struct GlobalKeybindPreferences: Codable, CustomStringConvertible {
    let function : Bool
    let control : Bool
    let command : Bool
    let shift : Bool
    let option : Bool
    let capsLock : Bool
    let carbonFlags : UInt32
    let characters : String?
    let keyCode : UInt32
    
    var description: String{return description("-")}
    
    func description(_ seperator: String = "") -> String{
        var stringBuilder = ""
        if self.control {
            stringBuilder += "Control\(seperator)"
        }
        if self.option {
            stringBuilder += "Option\(seperator)"
        }
        if self.command {
            stringBuilder += "Command\(seperator)"
        }
        if self.shift {
            stringBuilder += "Shift\(seperator)"
        }
        if self.capsLock {
            stringBuilder += "Capslock\(seperator)"
        }
        if let characters = self.characters {
            stringBuilder += "\(characters.uppercased())\(seperator)"
        }
        return "\(stringBuilder.dropLast(seperator.count))"
    }
}

extension GlobalKeybindPreferences{
    static var defaultKeyBind: GlobalKeybindPreferences{
        return GlobalKeybindPreferences(function: true, control: true, command: false, shift: false, option: false, capsLock: false, carbonFlags: 4096, characters: "1", keyCode: 18)
    }
}
