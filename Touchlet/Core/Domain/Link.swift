//
//  Link.swift
//  Touchlet
//
//  Created by Elias on 10/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class Link: NSObject, NSCoding {
    private struct NSCodingKeys {
        static let id = "id"
        static let title = "title"
        static let url = "url"
    }

    public let id: String
    public let title: String?
    public let url: URL
    
    public var displayTitle: String? {
        let host = url.host?.dropPrefix(prefix: "www.") ?? url.absoluteString
        return (title?.isEmpty ?? true) ? host : title
    }

    public required init(title: String?, url: URL, id: String = UUID().uuidString) {
        self.id = id
        self.title = title
        self.url = url
    }

    public convenience required init?(coder decoder: NSCoder) {
        guard let url = decoder.decodeObject(forKey: NSCodingKeys.url) as? URL, let id = decoder.decodeObject(forKey: NSCodingKeys.id) as? String else { return nil }
        let title = decoder.decodeObject(forKey: NSCodingKeys.title) as? String
        
        self.init(title: title, url: url, id: id)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: NSCodingKeys.title)
        coder.encode(url, forKey: NSCodingKeys.url)
        coder.encode(id, forKey: NSCodingKeys.id)
    }

    public override func isEqual(_ other: Any?) -> Bool {
        if let other = other as? Link{return id.elementsEqual(other.id)}
        else{return false}
    }
}
