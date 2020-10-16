//
//  MockUrlProtocol.swift
//  ImageDownloader_Example
//
//  Created by Vlad Borisenko on 7/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public class MockUrlProtocol: URLProtocol {
    // MARK: Properties
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    // MARK: Functions
    public override class func canInit(with request: URLRequest) -> Bool {
      return true
    }
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
      return request
    }
    public override func startLoading() {
      guard let handler = MockUrlProtocol.requestHandler else {
        return
      }
      do {
        let (response, data) = try handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = data {
          client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
      } catch {
        client?.urlProtocol(self, didFailWithError: error)
      }
    }
    public override func stopLoading() {}
}
