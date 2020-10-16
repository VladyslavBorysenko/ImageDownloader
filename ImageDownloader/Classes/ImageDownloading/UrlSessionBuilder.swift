//
//  UrlSessionBuilder.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/27/20.
//

import UIKit

class UrlSessionBuilder {
    // MARK: Init
    func urlSession(configuration: URLSessionConfiguration) -> URLSession {
        let session = URLSession(configuration: configuration)
        return session
    }
}
