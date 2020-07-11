//
//  WebsiteAssistance.swift
//  Touchlet
//
//  Created by Elias on 09/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import AppLib

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
    
    func update(link: Link) {
        do{
            if let index = try dataStore.findAll().firstIndex(of: link){
                update(at: index, with: link)
            }else{
                try dataStore.addBookmark(link)
            }
        }catch{
            Logger.log(text: "save bookmark \(link) failed \(error.localizedDescription)")
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
    
    func delete(link: Link){
        do{
            var bookmarks = try dataStore.findAll()
            bookmarks.removeAll{$0 == link}
            try dataStore.setBookmarks(bookmarks)
        }catch{
            Logger.log(text: "delete bookmark failed \(error.localizedDescription)")
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
