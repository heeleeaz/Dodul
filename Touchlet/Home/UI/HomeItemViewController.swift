//
//  _HomeItemViewController.swift
//  Touchlet
//
//  Created by Elias on 08/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import Core

class HomeItemViewController: NSViewController, NibLoadable{
    @IBOutlet weak var scrollView: NSScrollView!
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? NSViewController{
            controller.setValue(scrollView, forKey: #keyPath(scrollView))
        }
    }
}

