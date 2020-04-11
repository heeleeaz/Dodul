//
//  ViewController.swift
//  TouchletPanel
//
//  Created by Elias on 06/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import TouchletCore

class PanelWindow: NSPanel{
    override var contentView: NSView?{didSet{setFrame(.zero, display: true)}}
}

class PanelViewController: ReadonlyTouchBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let identifier = ProjectBundleProvider.instance.bundleIdentifier(for: .main)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(refreshTouchItems), name: .touchItemReload, object: identifier)
    }
    
    @objc func refreshTouchItems(){
        super.reloadItems()
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
}

