////
////  FeaturePackageStore.swift
////  Touchlet
////
////  Created by Elias on 08/01/2020.
////  Copyright © 2020 Elias Igbalajobi. All rights reserved.
////
//
//import Foundation
//
//public class CorePackageStore {
//    public static let instance = CorePackageStore.init()
//
//    private lazy var spotlight = { return SpotlightRepository.instance }()
//    private lazy var bookmark = { return BookmarkRepository() }()
//    
//    private init(){}
//    
//    func packageCount(type: CorePackageType) -> Int {
//        switch type {
//        case .App:
//            return -1
//        default:
//            return bookmark.bookmarksCount
//        }
//    }
//    
//    func packages(type: CorePackageType, completion: @escaping ([CorePackageItem])->()){
//        switch type {
//        case .App:
//            spotlight.callback = {completion($0.sortedItems.map{CorePackageItem($0)})}
//            spotlight.doSpotlightQuery()
//        default:
//            completion(bookmark.bookmarks.map{CorePackageItem($0)})
//        }
//    }
//    
//    func save(type: CorePackageType, item: [CorePackageItem]) {
//    }
//    
//    func deletePackage(type: CorePackageType, at index: Int) {
//    }
//}
