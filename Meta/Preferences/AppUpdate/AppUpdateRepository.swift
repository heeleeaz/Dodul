//
//  UpdateAPI.swift
//  TouchletMenu
//
//  Created by Elias on 23/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import MetaCore

class AppUpdateRepository{
    func requestVersion(_ completionHandler: @escaping (String?, Error?)->()){
        let request = NetworkRequest()
        request.setURL(url: "\(API.serverURL)/lastestVersion")
        request.request { (data, error) in
            if error != nil || data == nil{
                completionHandler(nil, error)
            }else{
                completionHandler(String(data: data!, encoding: .utf8), nil)
            }
        }
    }
}

struct VersionInfo: Codable {
    var version: String?
    var releaseNote: String?
    var releaseDxate: String?
    var state: String?
    var downloadLink: String?
    var buildVersion: String?
}
