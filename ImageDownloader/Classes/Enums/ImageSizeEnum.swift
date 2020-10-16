//
//  ImageSizeEnum.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/29/20.
//

public enum ImageSize {
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
