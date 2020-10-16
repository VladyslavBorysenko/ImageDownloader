//
//  BezierPathBuilder.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 8/3/20.
//

import Foundation

class BezierPathBuilder {
    private enum Constants {
        static let defaultStrokeWidth: CGFloat = 4
    }
    class func bezierPath(animation: DownLoadActivityAnimation) -> CustomBezierPath? {
        let path = UIBezierPath()
        switch animation {
        case .heartRate(let shapeColor):
            path.move(to: CGPoint(x: 0, y: 50))
            path.addLine(to: CGPoint(x: 10, y: 50))
            path.addLine(to: CGPoint(x: 30, y: 10))
            path.addLine(to: CGPoint(x: 50, y: 90))
            path.addLine(to: CGPoint(x: 70, y: 50))
            path.addLine(to: CGPoint(x: 90, y: 50))
            return CustomBezierPath(strokeWidth: Constants.defaultStrokeWidth,
                                    strokeColor: shapeColor,
                                    strokePath: path)
        case .customPath( let path, color: let color, width: let width):
            return CustomBezierPath(strokeWidth: width, strokeColor: color, strokePath: path)
        case .none, .customView:
            return nil
        }
    }
}
