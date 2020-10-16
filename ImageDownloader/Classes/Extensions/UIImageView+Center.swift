//
//  UIImageView+Center.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 04.08.2020.
//

import Foundation

// MARK: Extensions

extension UIView {
    public func alignToTheCenter(of parentView: UIView?) {
        guard let parentView = parentView else { return }
        // Define constant constraint size like as frame.size
        let childViewSize = self.frame.size
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: childViewSize.height).isActive = true
        self.widthAnchor.constraint(equalToConstant: childViewSize.width).isActive = true
        self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        self.centerXAnchor.constraint(lessThanOrEqualTo: parentView.centerXAnchor).isActive = true
    }
}
