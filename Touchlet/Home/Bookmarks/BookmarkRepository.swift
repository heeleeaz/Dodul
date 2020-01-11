//
//  WebsiteAssistance.swift
//  Touchlet
//
//  Created by Elias on 09/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

class BookmarkRepository{
    static let imageCacheName = "bookmarks"

    private var dataStore: BookmarkStore

    init(dataStore: BookmarkStore = BookmarkUserDefaults()) {
        self.dataStore = dataStore
    }

    var bookmarksCount: Int {
        return (try? dataStore.findAll())?.count ?? 0
    }
    
    var bookmarks: [Link]  {
        do{
            return try dataStore.findAll()
        }catch let error as NSError{
            Logger.log(text: "bookmark list failed \(error.userInfo)")
            return []
        }
    }

    func bookmark(atIndex index: Int) -> Link? {
        guard let links = try? dataStore.findAll() else { return nil }
        guard links.count > index else { return nil }
        return links[index]
    }
    
    func save(bookmark: Link) {
        do{
            try dataStore.addBookmark(bookmark)
        }catch let error as NSError{
            Logger.log(text: "Save bookmark \(bookmark) failed \(error.userInfo)")
        }
    }

    func moveBookmark(at fromIndex: Int, to toIndex: Int) {
        do{
            var bookmarks = try dataStore.findAll()
            let link = bookmarks.remove(at: fromIndex)
            bookmarks.insert(link, at: toIndex)
            try dataStore.setBookmarks(bookmarks)
        }catch let error as NSError{
            Logger.log(text: "Move bookmark failed \(error.userInfo)")
        }
    }

    func deleteBookmark(at index: Int) {
        do{
            var bookmarks = try dataStore.findAll()
            bookmarks.remove(at: index)
            try dataStore.setBookmarks(bookmarks)
        }catch let error as NSError{
            Logger.log(text: "Delete bookmark failed \(error.userInfo)")
        }
    }

    func updateBookmark(at index: Int, with link: Link) {
        do{
            var bookmarks = try dataStore.findAll()
            _ = bookmarks.remove(at: index)
            bookmarks.insert(link, at: index)
            try dataStore.setBookmarks(bookmarks)
        }catch let error as NSError{
            Logger.log(text: "Update bookmark failed \(error.userInfo)")
        }
    }
    
    func contains(url: URL) -> Bool {
        do{
            return try dataStore.findAll().firstIndex { $0.url == url } != nil
        }catch let error as NSError{
            Logger.log(text: "check contain bookmark failed \(error.userInfo)")
            return false
        }
    }
}
