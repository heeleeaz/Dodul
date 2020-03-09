//
//  TouchBarItemStore.swift
//  Touchlet
//
//  Created by Elias on 20/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

protocol TouchBarItemStore {
    func setItems(_ item: [TouchBarItem]) throws
    func findAll() throws -> [TouchBarItem]
    func addItem(_ item: TouchBarItem) throws
}
