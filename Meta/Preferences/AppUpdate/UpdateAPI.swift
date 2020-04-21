//
//  UpdateAPI.swift
//  TouchletMenu
//
//  Created by Elias on 23/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import MetaCore

class UpdateAPI{
    func requestVersion(_ completionHandler: @escaping (String?, Error?)->()){
        let request = NetworkRequest()
        request.setURL(url: "https://us-central1-touchlet-11807.cloudfunctions.net/lastestVersion")
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
    var releaseDate: String?
    var state: String?
    var downloadLink: String?
    var buildVersion: String?
}
