//
//  CacheManagerTests.swift
//  ImageDownloader_Tests
//
//  Created by Vlad Borisenko on 7/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import ImageDownloader

class CacheManagerTests: XCTestCase {
    // MARK: Constants
    private enum NamingConstants {
        static let imageForCaching = "testImageForCaching"
    }
    // MARK: Properties
    var cacheManager: CacheManager?
    // MARK: Inits
    override func setUp() {
        cacheManager = CacheManager()
    }
    override func tearDown() {
        cacheManager = nil
    }
    // MARK: Test Functions
    func testGettingNoCachedData() {
        // given
        let requestBuilder: RequestBuilder = RequestBuilder(cachePolicy: .returnCacheDataElseLoad, timeInterval: 60)
        let url = URL(string: "https://images.unsplash.com/photo-1595355728145-2c8d5863ccf0")
        guard let imageUrl = url, let urlRequest = requestBuilder.urlRequest(with: imageUrl, httpMethod: .get) else {
            XCTFail("Error during the creation test objects")
            return
        }
        // when
        let noCachedData = cacheManager?.cachedData(for: urlRequest)
        //then
        XCTAssertNil(noCachedData, "There is no cache for this url request")
    }
    func testTakingCachedData() {
        // given
        let url = URL(string: "https://images.unsplash.com/photo-1595495745866-982640a7d46f")
        let requestBuilder: RequestBuilder = RequestBuilder(cachePolicy: .returnCacheDataElseLoad, timeInterval: 60)
        guard let image = UIImage(named: NamingConstants.imageForCaching) else {return}
        let imgData = UIImageJPEGRepresentation(image, 1)
        // when
        guard let imageUrl = url,
            let imageData = imgData,
            let response = HTTPURLResponse(url: imageUrl, statusCode: 200, httpVersion: nil, headerFields: nil),
            let request = requestBuilder.urlRequest(with: imageUrl, httpMethod: .get) else {
            return XCTFail("Error during the creation objects")
        }
        self.cacheManager?.storeData(data: imageData, with: response, for: request)
        // then
        let cachedData = cacheManager?.cachedData(for: request)
        XCTAssertNotNil(cachedData, "There must be cached data for this url request")
    }
}
