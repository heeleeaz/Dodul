//
//  BookmarkUserDefault.swift
//  Touchlet
//
//  Created by Elias on 10/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

class BookmarkUserDefaults: BookmarkStore {
    public struct Constants {
        public static let groupName = "\(Global.groupIdPrefix).bookmarks"
    }

    private struct Keys {
        static let bookmarkKey = "com.heeleeaz.bookmarks.bookmarkKey"
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
        return userDefaults.set(data, forKey: Keys.bookmarkKey)
    }
    
    func findAll() throws -> [Link]{
        guard let data = userDefaults.data(forKey: Keys.bookmarkKey) else {return []}
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Link]
    }
}
