//
//  ViewController.swift
//  TouchletPanel
//
//  Created by Elias on 06/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa
import MetaCore

class MetaPanelViewController: ReadonlyTouchBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(refreshTouchItems), name: .touchItemReload, object: nil)
    }
    
    override func readonlyEmptyTouchBarItem(addButtonTapped touchBarItem: NSTouchBarItem) {
        Global.shared.launch(removeLast: 3, append: ["MacOS", Global.shared.appName(for: .meta)])
    }
    
    override func readonlyEmptyTouchBarItem(editButtonTapped touchBarItem: NSTouchBarItem) {
        Global.shared.launch(removeLast: 3, append: ["MacOS", Global.shared.appName(for: .meta)])
    }
    
    @objc func refreshTouchItems(){
        super.reloadItems()
        FaviconCacheProvider.shared.refresh()
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
}

class MetaPanelWindow: NSPanel{
    override var contentView: NSView?{didSet{setFrame(.zero, display: true)}}
    
    public override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        trackScreenViewEvent(screen: self.className) //track screenView
    }
}
