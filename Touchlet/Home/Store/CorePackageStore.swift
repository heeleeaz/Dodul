//
//  FeaturePackageStore.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public protocol CorePackageStore {
    func findAll(with snippetType: CorePackageType, result: @escaping (([CorePackageItem])->Void))
    func addPackageItems(_ items: [CorePackageItem])
    func addPackageItem(_ item: CorePackageItem)
}
