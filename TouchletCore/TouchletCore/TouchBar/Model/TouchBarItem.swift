//
//  TouchBarItem.swift
//  Touchlet
//
//  Created by Elias on 20/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import AppKit

public class TouchBarItem: NSObject, NSCoding{
    public var identifier: String!
    public var type: TouchBarItemType!
    
    public var itemState: State = .adding

    private struct NSCodingKeys {
        static let type = "type"
        static let identifier = "identifier"
    }
    
    public init(identifier: String, type: TouchBarItemType, state: State = .stored) {
        self.identifier = identifier
        self.type = type
        self.itemState = state
    }
    
    public override func isEqual(_ other: Any?) -> Bool {
        guard let other = other as? TouchBarItem else { return false }
        return identifier == other.identifier
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(identifier, forKey: NSCodingKeys.identifier)
        coder.encode(type.rawValue, forKey: NSCodingKeys.type)
    }
    
    public convenience required init?(coder: NSCoder) {
        guard let identifier = coder.decodeObject(forKey: NSCodingKeys.identifier) as? String else{return nil}
        let type = TouchBarItemType(rawValue: coder.decodeObject(forKey: NSCodingKeys.type) as! String)
        
        self.init(identifier: identifier, type: type!, state: .stored)
    }
}

extension TouchBarItem{    
    public enum TouchBarItemType: String {case Web = "Web", App = "App"}
    
    public enum State{case stored, dropped, adding}
}
