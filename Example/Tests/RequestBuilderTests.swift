//
//  RequestBuilderTests.swift
//  ImageDownloader_Tests
//
//  Created by Vlad Borisenko on 7/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import ImageDownloader

class RequestBuilderTests: XCTestCase {

    // MARK: Test Functions
    func testRequstCreationWithRightUrl() {
        let requestBuilder = RequestBuilder(cachePolicy: .returnCacheDataElseLoad, timeInterval: 60)
        // given
        let rightUrl = "https://images.unsplash.com/photo-1595355728145-2c8d5863ccf0"
        guard let url = URL(string: rightUrl) else {
            XCTFail("String with url must be right")
            return
        }
        // when
        let request = requestBuilder.urlRequest(with: url, httpMethod: .get)
        // then
        XCTAssertNotNil(request, "This request must be created, because of right URL")
    }
}
