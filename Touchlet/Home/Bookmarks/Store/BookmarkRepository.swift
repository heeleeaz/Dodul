//
//  WebsiteAssistance.swift
//  Touchlet
//
//  Created by Elias on 09/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import TouchletCore

public class BookmarkRepository: NSObject{
    public static let instance = BookmarkRepository()
        
    static let imageCacheName = "bookmarks"

    private var dataStore: BookmarkStore

    init(dataStore: BookmarkStore = BookmarkUserDefaults()) {
        self.dataStore = dataStore
    }

    var count: Int {return (try? dataStore.findAll())?.count ?? 0}
    
    var bookmarks: [Link]  {
        do{
            return try dataStore.findAll()
        }catch{
            Logger.log(text: "bookmark list failed \(error.localizedDescription)")
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
        }catch{
            Logger.log(text: "save bookmark \(bookmark) failed \(error.localizedDescription)")
        }
    }

    func move(at fromIndex: Int, to toIndex: Int) {
        do{
            var bookmarks = try dataStore.findAll()
            let link = bookmarks.remove(at: fromIndex)
            bookmarks.insert(link, at: toIndex)
            try dataStore.setBookmarks(bookmarks)
        }catch{
            Logger.log(text: "move bookmark failed \(error.localizedDescription)")
        }
    }

    func delete(at index: Int) {
        do{
            var bookmarks = try dataStore.findAll()
            bookmarks.remove(at: index)
            try dataStore.setBookmarks(bookmarks)
        }catch{
            Logger.log(text: "delete bookmark failed \(error.localizedDescription)")
        }
    }
    
    func delete(link: Link){
        do{
            var bookmarks = try dataStore.findAll()
            bookmarks.removeAll{$0 == link}
            try dataStore.setBookmarks(bookmarks)
        }catch{
            Logger.log(text: "delete bookmark failed \(error.localizedDescription)")
        }
    }
    
    func update(replace link: Link, with newLink: Link){
        do{
            if let index = try dataStore.findAll().firstIndex(of: link){
                update(at: index, with: newLink)
            }
        }catch{
            Logger.log(text: "update bookmark failed \(error.localizedDescription)")
        }
    }

    func update(at index: Int, with link: Link) {
        do{
            var bookmarks = try dataStore.findAll()
            _ = bookmarks.remove(at: index)
            bookmarks.insert(link, at: index)
            try dataStore.setBookmarks(bookmarks)
        }catch{
            Logger.log(text: "update bookmark failed \(error.localizedDescription)")
        }
    }
    
    func contains(link: Link) -> Bool{
        do{
            return try dataStore.findAll().contains(link)
        }catch{
            Logger.log(text: "check contain bookmark failed \(error.localizedDescription)")
            return false
        }
    }
}
