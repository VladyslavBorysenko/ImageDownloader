//
//  ImageDownloadingTests.swift
//  ImageDownloader_Tests
//
//  Created by Vlad Borisenko on 7/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ImageDownloader
import XCTest
import Foundation

class ImageDownloadingTests: XCTestCase {
    // MARK: Constants
    private enum Constants {
        static let testImageName = "testImage"
    }
    // MARK: Properties
    var imageDownloader: ImageDownloader?
    // MARK: Inits
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockUrlProtocol.self]
        imageDownloader = ImageDownloader(urlSessionConfiguration: configuration)
    }
    override func tearDown() {
        imageDownloader = nil
    }
    // MARK: Test functions
    func testDownloadingWithRightURL() {
        imageDownloader?.clearCache()
        // given
        let imageUrl = "https://images.unsplash.com/photo-1595355728145-2c8d5863ccf0"
        guard let testImage = UIImage(named: Constants.testImageName),
            let imgData = UIImageJPEGRepresentation(testImage, 1) else {
                XCTFail("Error during the test data creation")
                return
        }
        let exp = expectation(description: "Image loading")
        // when
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.incorrectResponse
            }
            let HTTPresponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            guard let response = HTTPresponse else { throw NetworkError.incorrectResponse }
            return (response, imgData)
        }
        // then
        imageDownloader?.downloadImage(with: imageUrl, scaleTo: .iconSize, completion: { (result) in
            switch result {
            case .success:
                exp.fulfill()
                return
            case .failure:
                XCTFail("Image with right url must be downloaded")
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    func testDownloadingImageWithWrongUrl () {
        imageDownloader?.clearCache()
        // given
        let wrongImageURL = "Some string without right url"
        let exp = expectation(description: "loading image")
        //then
        imageDownloader?.downloadImage(with: wrongImageURL, scaleTo: .iconSize, completion: { (result) in
            switch result {
            case .failure(let error):
                switch error {
                case .incorrectURL:
                    exp.fulfill()
                    return
                default:
                    XCTFail("There is wrong image URL, image has to throw exception incorrectURL")
                }
            default:
                XCTFail("There is wrong image URL, image has to throw exception")
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    func testDownloadingNewImageDirectFromNetwork() {
        imageDownloader?.clearCache()
        // given
        // 1.
        let newImageUrl = "https://images.unsplash.com/photo-1595837724936-2684bd9ec954?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=976&q=80" // size 10 mb.
        // 2.
        guard let image = UIImage(named: Constants.testImageName),
            let imgData = UIImageJPEGRepresentation(image, 1) else {
                XCTFail("Error during the test creation")
                return
        }
        var downloadedImage: UIImage?
        // 3.
        let exp = expectation(description: "ImageDownloading")
        // 4.
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.incorrectResponse
            }
            let HTTPresponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            guard let response = HTTPresponse else { throw NetworkError.incorrectResponse }
            return (response, imgData)
        }
        // when
        imageDownloader?.downloadImage(with: newImageUrl, scaleTo: .iconSize, completion: { (result) in
            exp.fulfill()
            switch result {
            case .success(let image):
                downloadedImage = image
                return
            case .failure:
                XCTFail("New image downloading must to take a time")
            }
        })
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(downloadedImage, "A new image has to take a time for downloading, when the cached image returns immediately")
    }
    func testDownloadingImageWithWrongData() {
        imageDownloader?.clearCache()
        // given
        let someUrlWithoutImage = "https://www.google.com/"
        let exp = expectation(description: "loading the image")
        let incorrectImgData = Data()
        //when
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.incorrectResponse
            }
            let HTTPresponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            guard let response = HTTPresponse else {
                XCTFail("Incorrect response")
                throw NetworkError.incorrectResponse
            }
            return (response, incorrectImgData)
        }
        //then
        imageDownloader?.downloadImage(with: someUrlWithoutImage, completion: { (result) in
            switch result {
            case .success:
                XCTFail("Incorrect data cannot be converted into image")
            case .failure(let error):
                switch error {
                case .incorrectData:
                    exp.fulfill()
                    return
                default:
                    XCTFail("Because of incorrect data, imageDownloader has to throw corresponding error")
                }
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testDownloadingImageFromCache() {
        imageDownloader?.clearCache()
        // given
        var networkVisited = false
        let newImageUrl = "https://images.unsplash.com/photo-1595837724936-2684bd9ec954?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=976&q=80"
        guard let testImage = UIImage(named: Constants.testImageName),
            let imgData = UIImageJPEGRepresentation(testImage, 1) else {
                XCTFail("Error during the creation test objects")
                return
        }
        // when
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.incorrectResponse
            }
            let HTTPresponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            guard let response = HTTPresponse else {
                XCTFail("Incorrect response")
                throw NetworkError.incorrectResponse
            }
            networkVisited.toggle()
            return (response, imgData)
        }
        let cachingExp = expectation(description: "Caching the image")
        imageDownloader?.downloadImage(with: newImageUrl, completion: { (result) in
            switch result {
            case .success:
                cachingExp.fulfill()
                return
            case .failure:
                XCTFail("Image has to be downloaded")
            }
            cachingExp.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        let getCacheExp = expectation(description: "Receiving the image")
        imageDownloader?.downloadImage(with: newImageUrl, scaleTo: .iconSize, completion: { (result) in
            switch result {
            case .success:
                getCacheExp.fulfill()
                return
            case .failure:
                XCTFail("New image downloading must to take a time")
            }
            getCacheExp.fulfill()
        })
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(networkVisited, "Cached image, can't invoke requestHandler")
    }
    func testSuccessfulResponse() {
        imageDownloader?.clearCache()
        // given
        guard let image = UIImage(named: Constants.testImageName) else {
            XCTFail("Image is invalid")
            return
        }
        let imgData = UIImageJPEGRepresentation(image, 1)
        // when
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.incorrectResponse
            }
            let HTTPresponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            guard let response = HTTPresponse else {throw NetworkError.incorrectResponse}
            return (response, imgData)
        }
        // then
        let exp = expectation(description: "Loading image")
        imageDownloader?.downloadImage(with: "https://images.unsplash.com/photo-1544913776-90c1223073a3", completion: { (result) in
            switch result {
            case .failure:
                XCTFail("Request with successful response must be completed")
            case .success:
                exp.fulfill()
                return
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testUnseccessfulResponse() {
        imageDownloader?.clearCache()
        // given
        let imgData = Data()
        // when
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.incorrectResponse
            }
            let HTTPresponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
            guard let response = HTTPresponse else {throw NetworkError.incorrectResponse}
            return (response, imgData)
        }
        // then
        let exp = expectation(description: "Loading response")
        imageDownloader?.downloadImage(with: "https://images.unsplash.com/photo-1545105511-839f4a45a030", completion: { (result) in
            switch result {
            case .failure(let error):
                switch error {
                case .httpError:
                    exp.fulfill()
                    return
                default:
                    XCTFail("Response with code 400 has to throw httpError")
                    return
                }
            case .success:
                XCTFail("Response with code 400 has to throw httpError")
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 9, handler: nil)
    }
}
