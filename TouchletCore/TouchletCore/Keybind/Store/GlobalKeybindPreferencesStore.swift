//
//  HotKeyStore.swift
//  Touchlet
//
//  Created by Elias on 24/02/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public struct GlobalKeybindPreferencesStore{
    static let KEYCODE_CACHE_KEY = "HotKey_2"
    
    public static func save(keyBind: GlobalKeybindPreferences){
        let cache = (try? Cache.loadFromDisk(withName: KEYCODE_CACHE_KEY)) ?? Cache<String, GlobalKeybindPreferences>()
        cache.insert(keyBind, forKey: KEYCODE_CACHE_KEY)
        try? cache.saveToDisk(withName: KEYCODE_CACHE_KEY)
    }
    
    public static func remove(){
        if let cache = (try? Cache<String, GlobalKeybindPreferences>.loadFromDisk(withName: KEYCODE_CACHE_KEY)){
            cache.removeValue(forKey: KEYCODE_CACHE_KEY)
            try? cache.saveToDisk(withName: KEYCODE_CACHE_KEY)
        }
    }
    
    public static func fetch() -> GlobalKeybindPreferences?{
        return (try? Cache<String, GlobalKeybindPreferences>.loadFromDisk(withName: KEYCODE_CACHE_KEY))?.value(forKey: KEYCODE_CACHE_KEY)
    }
}
