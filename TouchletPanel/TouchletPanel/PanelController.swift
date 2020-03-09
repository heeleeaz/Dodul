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
    override var contentView: NSView?{
        didSet{
            setFrame(.zero, display: true)
            setContentSize(frame.size)
        }
    }
}

class PanelWindowController: NSWindowController{
    override func makeTouchBar() -> NSTouchBar?{
        return contentViewController?.makeTouchBar()
    }
}

class PanelViewController: ReadonlyTouchBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(refreshTouchItems), name: Constants.refreshTouchItemNotification, object: Constants.menuAppBundleIdentifier)
    }
    
    @objc func refreshTouchItems(){
        super.refreshTouchBarItems()
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
}

extension PanelViewController{
    struct Constants {
        static let refreshTouchItemNotification = Notification.Name("refreshTouchItem")
        static let menuAppBundleIdentifier = "com.heeleeaz.touchlet.TouchletMenu"
    }
}

