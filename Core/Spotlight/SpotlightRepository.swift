//
//  AppSupportManager.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

public class SpotlightRepository{
    public static var whitelist: [String] = {
        guard let path = Bundle.main.path(forResource: "SpotlightWhitelist", ofType: "json"),
            let data = try? Data(contentsOf: URL.init(fileURLWithPath: path)) else {return []}
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }()
    
    public static var instance = SpotlightRepository()
    
    public var callback: ((SpotlightResult) -> ())?

    private var metaQuery: NSMetadataQuery? {willSet {if let query = self.metaQuery {query.stop()}}}

    private init(){}

    public func query() {
        metaQuery = NSMetadataQuery()
        metaQuery?.searchScopes = ["/Applications"]
        let predicate = NSPredicate(format: "kMDItemContentType == 'com.apple.application-bundle'")
        NotificationCenter.default.addObserver(self, selector: #selector(queryDidFinish(_:)), name: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: nil)
        metaQuery?.predicate = predicate
        metaQuery?.start()
    }

    @objc func queryDidFinish(_ notification: NSNotification) {
        guard let query = notification.object as? NSMetadataQuery else {return}
        
        var items: [SpotlightItem] = []
        for result in query.results {
            guard let item = result as? NSMetadataItem, let identifer = item.value(forAttribute: kMDItemCFBundleIdentifier as String) as? String else {continue}
            let lastUsed = item.value(forAttribute: kMDItemLastUsedDate as String) as? Date ?? Date.init(timeIntervalSince1970: 0)
            let displayName = item.value(forAttribute: kMDItemDisplayName as String) as? String
            let useCount = item.value(forAttribute: "kMDItemUseCount") as? Int ?? 0
            items.append(SpotlightItem(bundleIdentifier: identifer, displayName: displayName, lastUsed: lastUsed, useCount: useCount))            
        }
        callback?(SpotlightResult(items: items))
//        print((query.results[0] as? NSMetadataItem)?.attributes)
    }
    
    public static func findAppIcon(bundleIdentifier: String) -> NSImage?{
        let workspace = NSWorkspace.shared
        if let path = workspace.absolutePathForApplication(withBundleIdentifier: bundleIdentifier){
            return workspace.icon(forFile: path)
        }
        return nil
    }
}
