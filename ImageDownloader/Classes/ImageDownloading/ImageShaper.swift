//
//  ImageShaper.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/28/20.
//

import UIKit

class ImageShaper {
    // MARK: Singleton
    static let shared = ImageShaper()
    // MARK: Inits
    private init() {}
    // MARK: Funcions
    public func transformImageTo(_ image: UIImage, to form: ImageForm) -> UIImage {
        switch form {
        case .normal:
            return image
        case .rounded:
            guard let tranformedImage = roundImage(image, with: form.value()) else {
                return image
            }
            return tranformedImage
        case .round:
            guard let tranformedImage = roundImage(image, with: form.value()) else {
                return image
            }
            return tranformedImage
        }
    }
}

private func roundImage(_ image: UIImage, with radius: CGFloat) -> UIImage? {
    let maxRadius = min(image.size.width, image.size.height)
    let cornerRadius: CGFloat
    if radius > 0 && radius <= maxRadius {
        cornerRadius = radius
    } else {
        cornerRadius = maxRadius
    }
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let rect = CGRect(origin: .zero, size: image.size)
    UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
    image.draw(in: rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
