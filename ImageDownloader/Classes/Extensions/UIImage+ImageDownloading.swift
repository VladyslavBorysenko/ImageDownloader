//
//  UIImage+ImageDownloading.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 7/29/20.
//

import UIKit

// MARK: Extension
extension UIImageView {
    public func setImage(with url: String,
                         placeholder: UIImage? = nil,
                         tranformTo shape: ImageForm = .normal,
                         resizeTo size: ImageSize = .iconSize,
                         activityIndicator: DownLoadActivityAnimation = .none,
                         completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.image = placeholder
        }
        Animator.shared.start(animation: activityIndicator, on: self)
        ImageDownloader.shared.downloadImage(with: url, scaleTo: size) { (result) in
            defer { Animator.shared.stop(on: self) }
            switch result {
            case .failure(let error):
                print("Downloading image \(url) was failed. The reason is \(error.description)")
                return
            case .success(let downloadedImage):
                self.image = ImageShaper.shared.transformImageTo(downloadedImage, to: shape)
            }
            if let completion = completion {
                completion()
            }
        }
    }
}
