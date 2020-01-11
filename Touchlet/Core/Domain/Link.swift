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
        static let title = "title"
        static let url = "url"
    }

    public let title: String?
    public let url: URL
    
    public var displayTitle: String? {
        let host = url.host?.dropPrefix(prefix: "www.") ?? url.absoluteString
        return (title?.isEmpty ?? true) ? host : title
    }

    public required init(title: String?, url: URL) {
        self.title = title
        self.url = url
    }

    public convenience required init?(coder decoder: NSCoder) {
        guard let url = decoder.decodeObject(forKey: NSCodingKeys.url) as? URL else { return nil }
        let title = decoder.decodeObject(forKey: NSCodingKeys.title) as? String
        self.init(title: title, url: url)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: NSCodingKeys.title)
        coder.encode(url, forKey: NSCodingKeys.url)
    }

    public override func isEqual(_ other: Any?) -> Bool {
        guard let other = other as? Link else { return false }
        return title == other.title && url == other.url
    }

    public func merge(with other: Link) -> Link {
        if url != other.url {return self}
        let mergeTitle = (title == nil || title!.isEmpty) ? other.title : title
        return Link(title: mergeTitle, url: url)
    }
}
