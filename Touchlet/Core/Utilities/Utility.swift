//
//  Utility.swift
//  Touchlet
//
//  Created by Elias on 21/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Cocoa

func terminateApp(_ sender: Any){
    NSApplication.shared.terminate(sender)
}

func synced(_ lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
