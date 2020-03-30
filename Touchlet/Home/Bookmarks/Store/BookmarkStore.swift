//
//  BookmarkStore.swift
//  Touchlet
//
//  Created by Elias on 10/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public protocol BookmarkStore {
    func setBookmarks(_ bookmark: [Link]) throws
    func findAll() throws -> [Link]
    func addBookmark(_ bookmark: Link) throws
}
