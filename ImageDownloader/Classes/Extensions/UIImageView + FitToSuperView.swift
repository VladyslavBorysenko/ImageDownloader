//
//  UIImageView + Imposing.swift
//  ImageDownloader
//
//  Created by Vlad Borisenko on 8/6/20.
//

import Foundation

// MARK: Extensions

extension UIView {
    public func fitToSuperView() {
        guard let parentView = self.superview else {
            assertionFailure("There is no superView for called view")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
