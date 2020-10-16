//
//  ActivityIndicator.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 8/3/20.
//

import Foundation

public enum DownLoadActivityAnimation {
    case none
    case heartRate(shapeColor: UIColor)
    case customView(_ view: UIView)
    case customPath(_ path: UIBezierPath, color: UIColor, width: CGFloat)
}
