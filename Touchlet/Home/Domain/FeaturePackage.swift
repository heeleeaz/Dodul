//
//  HomeItem.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public struct CorePackageItem: Codable{
    var id: String!
    var type: CorePackageType!
    var title: String?
    var url: String?
}

public enum CorePackageType: String, Codable, CaseIterable{
    case App = "Application", Web = "Web Pages"
}
