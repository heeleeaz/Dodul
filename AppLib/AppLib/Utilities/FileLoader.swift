//
//  FileLoader.swift
//  Touchlet
//
//  Created by Elias on 07/01/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

enum FileError: Error {
    case unknownFile
    case invalidFileContents
}

class FileLoader {
    func load(fileName: String, fromBundle bundle: Bundle) throws -> Data {
        
        let fileUrl = URL(fileURLWithPath: fileName)
        let baseName = fileUrl.deletingPathExtension().path
        let ext = fileUrl.pathExtension
        
        guard let path = bundle.path(forResource: baseName, ofType: ext) else { throw  FileError.unknownFile }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url, options: [.mappedIfSafe]) else { throw  FileError.invalidFileContents }
        return data
    }
}
