//
//  NetworkRequest.swift
//  TouchletCore
//
//  Created by Elias on 23/03/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

public class NetworkRequest {
    private var url: String!
    private var method = HTTPMethod.GET
    private var headers: [String: String] = [:]
    private var httpBody: Data?
    private var queryItems: [String: String] = [:]
    
    public init() {
    }

    public func setURL(url: String) {
        self.url = url;
    }

    public func addHeader(key: String, value: String) {
        headers[key] = value;
    }

    public func setBody(data: Data?) {
        self.httpBody = data;
    }

    public func setMethod(method: HTTPMethod) {
        self.method = method
    }

    public func addQuery(key: String, value: String) {
        queryItems[key] = value
    }

    public func request(_ completionHandler: @escaping ((Data?, Error?) -> Void)) {
        var components = URLComponents(string: url)!
        components.queryItems = self.queryItems.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }

        var request = URLRequest(url: components.url!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
                let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode,
                error == nil { completionHandler(data, nil) }
            else { completionHandler(data, Error.requestFailed) }
        }.resume()
    }

    public enum HTTPMethod: String {
        case GET = "get"
        case HEAD = "head"
        case POST = "post"
        case PUT = "put"
        case DELETE = "delete"
        case CONNECT = "connect"
        case OPTIONS = "options"
        case TRACE = "trace"
        case PATCH = "patch"
    }

    public enum Error: Swift.Error {
        case requestFailed
    }
}
