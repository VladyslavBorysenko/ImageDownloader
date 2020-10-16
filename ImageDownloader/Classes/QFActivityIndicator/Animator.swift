//
//  LoadingIndicator.swift
//  pulseAnimation
//
//  Created by Vlad Borisenko on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
// MARK: Constants
private enum Constants {
    static let animationStartPosition = 0.0
    static let animationFinishPosition = 1.0
    static let animationDuration: Double = 1
}
class Animator {
    // MARK: Singleton
    static var shared = Animator()
    // MARK: Properties
    private var shapeLayers: [CAShapeLayer] = []
    private var currentShapeLayer: CAShapeLayer?
    private var animatedShapeSize: CGSize = CGSize(width: 0, height: 0)
    // MARK: Init
    private init() {}
    // MARK: Functions
    public func start(animation: DownLoadActivityAnimation, on view: UIView) {
        stop(on: view)
        switch animation {
        // If choosen animation is .none, just return
        case .none:
            return
        case .customView(let animatableView):
            let viewWithAnimation = animatableView
            view.addSubview(viewWithAnimation)
            // Fit defined custom view to the parent ImageView
            viewWithAnimation.fitToSuperView()
        case .customPath, .heartRate:
            guard let choosenShapeBezPath = BezierPathBuilder.bezierPath(animation: animation) else {
                assertionFailure("There is error with BezierPath")
                return
            }
            animatedShapeSize = CGSize(width: choosenShapeBezPath.strokePath.bounds.width,
                                       height: choosenShapeBezPath.strokePath.bounds.height)
            // Create transparent view based on animated shape size
            let animatedView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                                    size: animatedShapeSize))
            view.addSubview(animatedView)
            let shapeLayer = configureAnimatedShapeLayer(with: choosenShapeBezPath)
            animatedView.layer.addSublayer(shapeLayer)
            // Center animatedView
            animatedView.alignToTheCenter(of: view)
            currentShapeLayer = shapeLayer
            configureAnimation()
        }
    }
    public func stop(on view: UIView) {
        view.subviews.forEach { $0.removeFromSuperview() }
    }
    private func configureAnimatedShapeLayer(with path: CustomBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = path.strokeColor.cgColor
        shapeLayer.frame = CGRect(x: 0,
                                  y: 0,
                                  width: animatedShapeSize.width,
                                  height: animatedShapeSize.height)
        shapeLayer.path = path.strokePath.cgPath
        shapeLayer.lineWidth = path.strokeWidth
        shapeLayers.append(shapeLayer)
        return shapeLayer
    }
    private func createAnimation(keyPath: String,
                                 startPosition: Double,
                                 endPosition: Double,
                                 duration: Double,
                                 beginTime: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = startPosition
        animation.toValue = endPosition
        animation.duration = duration
        animation.beginTime = beginTime
        return animation
    }
    private func configureAnimation() {
        let startAnimation = createAnimation(keyPath: "strokeEnd",
                                             startPosition: Constants.animationStartPosition,
                                             endPosition: Constants.animationFinishPosition,
                                             duration: Constants.animationDuration,
                                             beginTime: 0)
        let reverseAnimation = createAnimation(keyPath: "strokeStart",
                                               startPosition: Constants.animationStartPosition,
                                               endPosition: Constants.animationFinishPosition,
                                               duration: Constants.animationDuration,
                                               beginTime: Constants.animationDuration)
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [reverseAnimation, startAnimation]
        animationGroup.repeatCount = .infinity
        animationGroup.autoreverses = false
        animationGroup.duration = Constants.animationDuration * 2
        currentShapeLayer?.add(animationGroup, forKey: "moving")
    }
}
