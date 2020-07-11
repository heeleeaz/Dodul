//
//  AppPrefs.swift
//  Meta
//
//  Created by Elias on 25/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import AppLib

class AppPrefs{
    static let shared = AppPrefs()
    
    public struct Constants {
        static let groupName = "\(Global.instance.APP_SECURITY_GROUP).app_prefs_0"
        static let setupDefaultBookmark = "defaultBookmarks"
    }
    
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults(suiteName: Constants.groupName)!) {
        self.userDefaults = userDefaults
    }
    
    var hasSetupDefaultBookmark: Bool{
        set{
            userDefaults.set(newValue, forKey: Constants.setupDefaultBookmark)
        }
        get{
            userDefaults.bool(forKey: Constants.setupDefaultBookmark)
        }
    }
}
