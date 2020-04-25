//
//  BookmarkWebservice.swift
//  Meta
//
//  Created by Elias on 25/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import MetaCore

class BookmarkWebService{
    static let shared = BookmarkWebService()
    
    func defaultBookmarks(_ completionHandler: @escaping ([Link]?, Error?)->()){
        let request = NetworkRequest()
        request.setURL(url: "https://us-central1-touchlet-11807.cloudfunctions.net/defaultBookmarks")
        request.request { (data, error) in
            if let data = data, let links = try? JSONDecoder().decode([Link].self, from: data){
                completionHandler(links, nil)
            }else{
                completionHandler(nil, error)
            }
        }
    }
}
