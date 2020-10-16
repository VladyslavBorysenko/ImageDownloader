//
//  BezierPath.swift
//  pulseAnimation
//
//  Created by Vlad Borisenko on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

public struct CustomBezierPath {
    // MARK: Properties
    let strokeWidth: CGFloat
    let strokeColor: UIColor
    let strokePath: UIBezierPath
    // MARK: Init
    public init (strokeWidth: CGFloat,
                 strokeColor: UIColor,
                 strokePath: UIBezierPath) {
        self.strokePath = strokePath
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
    }
}
