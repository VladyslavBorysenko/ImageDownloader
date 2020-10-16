//
//  ImageRendererTests.swift
//  ImageDownloader_Tests
//
//  Created by Vlad Borisenko on 7/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import ImageDownloader

class ImageRendererTests: XCTestCase {
    // MARK: Constants
    private enum NamingConstants {
        static let imageWithBigSize = "bigSizeImage"
    }
    private enum ImageSize {
        case iconSize
        case cellSize
        case pictureSize
        case customSize (Int, Int)
        func value() -> CGSize {
            switch self {
            case .cellSize:
                return CGSize(width: 300, height: 300)
            case .iconSize:
                return CGSize(width: 128, height: 128)
            case .pictureSize:
                return CGSize(width: 600, height: 600)
            case .customSize(let width, let height):
                return CGSize(width: width, height: height)
            }
        }
    }

    // MARK: Properties
    var imageRenderer: ImageRenderManager?
    // MARK: Inits
    override func setUp() {
        imageRenderer = ImageRenderManager()
    }

    override func tearDown() {
        imageRenderer = nil
    }

    // MARK: Test functions
    func testImageCompressing() {
        // given
        guard let sourceImage = UIImage(named: NamingConstants.imageWithBigSize) else {
            XCTFail("Choosen image is not avaliable")
            return
        }
        // when
        guard let sourceImageData = UIImageJPEGRepresentation(sourceImage, 1) else {
            XCTFail("Image data is not correct")
            return
        }
        guard let compressedImagaData = imageRenderer?.compressImage(sourceImageData) else {
            XCTFail("Error during the image compression")
            return
        }
        // then
        XCTAssertLessThan(compressedImagaData.count, sourceImageData.count)
    }
    func testImageResizing() {
        // given
        guard let sourceImage = UIImage(named: NamingConstants.imageWithBigSize) else {
            XCTFail("Choosen image is not avaliable")
            return
        }
        // when
        guard let resizedImage = imageRenderer?.resizeImage(sourceImage, to: ImageSize.cellSize.value()) else {
            XCTFail("Error during the image resizing")
            return
        }
        // then
        XCTAssertLessThan(resizedImage.size.width, sourceImage.size.width, "Resised image must be less than source")
        if sourceImage.size.width > sourceImage.size.height {
            XCTAssertEqual(resizedImage.size.width, ImageSize.cellSize.value().width, "Image was resized to wrong size")
        } else {
            XCTAssertEqual(resizedImage.size.height, ImageSize.cellSize.value().height, "Image was resized to wrong size")
        }
    }

}
