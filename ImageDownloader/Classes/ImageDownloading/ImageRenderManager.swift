//
//  ImageRenderManager.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/22/20.
//

import UIKit

class ImageRenderManager {
    // MARK: Fuctions
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage {
        var scale: CGFloat = 1
        if image.size.width > image.size.height {
            scale = size.width / image.size.width
        } else {
            scale = size.height / image.size.height
        }
        let newHeight = image.size.height * scale
        let newSize = CGSize(width: size.width, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in ()
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    func compressImage(_ data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let compressedImageData = UIImageJPEGRepresentation(image, 0)
        return compressedImageData
    }
}
