//
//  ProjectBundleConstants.swift
//  TouchletMenu
//
//  Created by Elias on 29/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

extension Notification.Name{
    public static let hotKeySetup = NSNotification.Name("HOTKEY_SETUP")
    public static let touchItemReload = Notification.Name("refreshTouchItem")
    public static let killApp = NSNotification.Name("KILLAPP")
}
