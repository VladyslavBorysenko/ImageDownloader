//
//  Request.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/13/20.
//

import Foundation

class RequestBuilder {
    public enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    // MARK: Properties
    private var cachePolicy: URLRequest.CachePolicy
    private var timeOutInterval: TimeInterval
    // MARK: Inits
    init (cachePolicy: URLRequest.CachePolicy, timeInterval: TimeInterval) {
        self.cachePolicy = cachePolicy
        self.timeOutInterval = timeInterval
    }
    // MARK: Functions
    func urlRequest(with url: URL, httpMethod: HTTPMethod) -> URLRequest? {
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeOutInterval)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}
