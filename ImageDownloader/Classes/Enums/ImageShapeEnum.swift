//
//  ImageShapeEnum.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/29/20.
//

import Foundation

public enum ImageForm {
    case normal
    case round
    case rounded
    func value() -> CGFloat {
        switch self {
        case .normal:
            return 0
        case .round:
            return 50
        case .rounded:
            return 10
        }
    }
}
