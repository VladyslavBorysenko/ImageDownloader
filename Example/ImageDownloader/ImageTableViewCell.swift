//
//  ImageTableViewCell.swift
//  ImageDownloader_Example
//
//  Created by Vlad Borisenko on 7/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ImageDownloader

class ImageTableViewCell: UITableViewCell {
    // MARK: IBActions
    @IBOutlet weak var displayedImage: UIImageView!
    // MARK: Functions
    func resetCellImage() {
        displayedImage.image = nil
    }
}
