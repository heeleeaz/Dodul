//
//  Response.swift
//  SwiftLinkPreview
//
//  Created by Giuseppe Travasoni on 20/11/2018.
//  Copyright © 2018 leocardz.com. All rights reserved.
//

import Foundation

public struct Response {
    init() { }
    var url: URL?
    var finalUrl: URL?
    var canonicalUrl: String?
    var title: String?
    var description: String?
    var images: [String]?
    var image: String?
    var icon: String?
    var video: String?
    var price: String?
}
