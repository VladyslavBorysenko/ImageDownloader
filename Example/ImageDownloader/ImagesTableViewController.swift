//
//  ImagesTableViewController.swift
//  ImageDownloader_Example
//
//  Created by Vlad Borisenko on 7/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ImageDownloader

class ImagesTableViewController: UITableViewController {
    // MARK: Constants
    private enum Constants {
        enum ImageName {
            static let defaultImage = "defaultImage"
            static let imageForAnimatableView = "bigSizeImage"
        }
        enum CircleShapeParameters {
            static let cirlceWidth = 40
            static let circleHeight = 40
            static let borderWidth: CGFloat = 4
        }
    }
    // MARK: Properties
    let imagesURLs = ["https://images.unsplash.com/photo-1595161397851-cb282659df5e",
                      "https://images.unsplash.com/photo-1595132169434-097c5ae1a145",
                      "https://images.unsplash.com/photo-1595144593798--8f7e34c157aa",
                      "https://images.unsplash.com/photo-1594823204889-68bcbb0e549e",
                      "https://images.unsplash.com/photo-1594149596808-e3b6174968b3",
                      "https://images.unsplash.com/photo-1595087394571-235bacfa018f",
                      "https://images.unsplash.com/photo-1595136595835-198de8aa2199",
                      "https://images.unsplash.com/photo-1595132938692-83ad2c098e47",
                      "https://images.unsplash.com/photo-1595134816826-c569cbb602b2",
                      "https://images.unsplash.com/photo-1595086135888-942899e89e46",
                      "https://images.unsplash.com/photo-1595133588854-17ec1ace138b",
                      "https://images.unsplash.com/photo-1595119293311-fa1b07af62a3",
                      "https://images.unsplash.com/photo-1594886801340-88d2d9c028e2",
                      "https://images.unsplash.com/photo-1595110966661-19a2d2fc8087",
                      "https://images.unsplash.com/photo-1593642532781-03e79bf5bec2",
                      "https://images.unsplash.com/photo-1595101805915-963ec7b9b45a",
                      "https://images.unsplash.com/photo-1595131264558-6094fd5428de",
                      "https://images.unsplash.com/photo-1595100930017-8d4112e87959",
                      "https://images.unsplash.com/photo-1595111073400-ba90b1ba5140",
                      "https://images.unsplash.com/photo-1595113230628-4753b62f4427"]
    // MARK: ControllerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesURLs.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell",
                                                       for: indexPath) as? ImageTableViewCell else {
                                                        return tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        }
        cell.resetCellImage()
        
        let someImageView = UIImageView(image: UIImage(named: Constants.ImageName.imageForAnimatableView))
        
        cell.displayedImage.setImage(with: self.imagesURLs[indexPath.row], placeholder: nil, tranformTo: .round, resizeTo: .iconSize, activityIndicator: .customView(someImageView), completion: nil)
        return cell
    }
}
