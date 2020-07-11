//
//  BookmarkWebservice.swift
//  Meta
//
//  Created by Elias on 25/04/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation
import AppLib

class BookmarkWebService{
    static let shared = BookmarkWebService()
    
    func getBookmarks(_ complete: @escaping ([Link]?, Error?)->()){
        let request = NetworkRequest()
        request.setURL(url: "\(API.serverURL)/defaultBookmarks")
        request.request { (data, error) in
            if let data = data, let links = try? JSONDecoder().decode([Link].self, from: data){
                complete(links, nil)
            }else{
                complete(nil, error)
            }
        }
    }
}
