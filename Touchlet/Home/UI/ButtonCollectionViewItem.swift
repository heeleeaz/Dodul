//
//  TextCollectionViewItem.swift
//  Touchlet
//
//  Created by Elias on 16/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

class ButtonCollectionViewItem: NSCollectionViewItem {
    static let reuseIdentifier = NSUserInterfaceItemIdentifier("TextCollectionViewItem")
    
    @IBOutlet weak var button: NSButton!
    
    func showAction(action: Action, _ didTap: (()->())?){
        switch action {
        case .plusIcon:
            button.image = NSImage(named: "PlusIcon")
        default:
            button.title = "See more"
        }
        
        button.addClickGestureRecognizer { didTap?() }
    }
    
    enum Action {
        case seeMore, plusIcon
    }
}
