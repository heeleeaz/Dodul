//
//  BookmarkUserDefault.swift
//  Touchlet
//
//  Created by Elias on 10/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import MetaCore

class BookmarkUserDefaults: BookmarkStore {
    public struct Constants {
        static let groupName = "\(Global.groupIdPrefix).bookmarks_0_"
        static let bookmarkKey = "bookmark"
    }
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults(suiteName: Constants.groupName)!) {
        self.userDefaults = userDefaults
    }
    
    func addBookmark(_ bookmark: Link) throws {
        var newBookmarks = try findAll()
        newBookmarks.append(bookmark)
        try setBookmarks(newBookmarks)
    }
    
    func setBookmarks(_ bookmark: [Link]) throws {
        let data = try NSKeyedArchiver.archivedData(withRootObject: bookmark, requiringSecureCoding: false)
        return userDefaults.set(data, forKey: Constants.bookmarkKey)
    }
    
    func findAll() throws -> [Link]{
        guard let data = userDefaults.data(forKey: Constants.bookmarkKey) else {return []}
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Link]
    }
}
