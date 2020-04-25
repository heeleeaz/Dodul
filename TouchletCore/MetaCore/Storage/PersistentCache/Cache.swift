//
//  ImageCache.swift
//  Touchlet
//
//  Created by Elias on 15/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()
    
    public init(
        dateProvider: @escaping () -> Date = Date.init,
        entryLifetime: TimeInterval = TimeInterval(Int.max) /*68yrs*/,
        maximumEntryCount: Int = 100000) {
        
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        self.wrapped.countLimit = maximumEntryCount
        self.wrapped.delegate = keyTracker
    }
    
    public func insert(_ value: Value, forKey key: Key) {
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(key: key, value: value, expirationDate: date)
        wrapped.setObject(entry, forKey: WrappedKey(key))
        keyTracker.keys.insert(key)
    }
    
    public func insert(_ entry: Entry) {
        insert(entry.value, forKey: entry.key)
    }

    public func value(forKey key: Key) -> Value? {
        return entry(forKey: key)?.value
    }
    
    public func entry(forKey key: Key) -> Entry? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {return nil}

        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }

        return entry
    }

    public func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
    public subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }
}

extension Cache{
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {return false}
            return value.key == key
        }
    }
    
    public final class Entry {
        let key: Key
        let value: Value
        let expirationDate: Date

        init(key: Key, value: Value, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
    
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject object: Any) {
            guard let entry = object as? Entry else {return}

            keys.remove(entry.key)
        }
    }
}

extension Cache: Codable where Key: Codable, Value: Codable {
    convenience public init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        entries.forEach(insert)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(keyTracker.keys.compactMap(entry))
    }
}

extension Cache where Key: Codable, Value: Codable {
    public func saveToDisk(withName name: String, using fileManager: FileManager = .default) throws {
        if let folderURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Global.groupIdPrefix){
            let fileURL = folderURL.appendingPathComponent(name + ".c")
            let data = try JSONEncoder().encode(self)
            try data.write(to: fileURL)
        }else{
            throw NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: nil)
        }
    }
    
    public static func loadFromDisk(withName name: String, using fileManager: FileManager = .default) throws -> Cache {
        if let folderURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: Global.groupIdPrefix){
            let fileURL = folderURL.appendingPathComponent(name + ".c")
            let data = try Data(contentsOf: fileURL)
            
            return try JSONDecoder().decode(Cache.self, from: data)
        }else{
            throw NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: nil)
        }
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {}
