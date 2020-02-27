//
//  TouchBarItem.swift
//  Touchlet
//
//  Created by Elias on 20/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class TouchBarItem: NSObject, NSCoding{
    var identifier: String!
    var type: TouchBarItemType!

    private struct NSCodingKeys {
        static let type = "type"
        static let identifier = "identifier"
    }
    
    init(identifier: String, type: TouchBarItemType) {
        self.identifier = identifier
        self.type = type
    }
    
    public override func isEqual(_ other: Any?) -> Bool {
        guard let other = other as? TouchBarItem else { return false }
        return identifier == other.identifier
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(identifier, forKey: NSCodingKeys.identifier)
        coder.encode(type.rawValue, forKey: NSCodingKeys.type)
    }
    
    public convenience required init?(coder: NSCoder) {
        guard let identifier = coder.decodeObject(forKey: NSCodingKeys.identifier) as? String else{return nil}
        let type = TouchBarItemType(rawValue: coder.decodeObject(forKey: NSCodingKeys.type) as! String)
        
        self.init(identifier: identifier, type: type!)
    }
}

extension TouchBarItem{
    var touchBarIdentifier: NSTouchBarItem.Identifier  {
        let touchID = "\(MainWindowController.Constants.customizationIdentifier).\(identifier!)"
        return NSTouchBarItem.Identifier(touchID)
    }
    
    enum TouchBarItemType: String {
        case Web = "Web", App = "App"
    }
    
    var iconImage: NSImage?{
        switch type {
        case .App:
            return SpotlightRepository.findAppIcon(bundleIdentifier: identifier)
        default:
            return FaviconProvider.instance.loadFromCache(url: URL(string: identifier)!)
        }
    }
}
