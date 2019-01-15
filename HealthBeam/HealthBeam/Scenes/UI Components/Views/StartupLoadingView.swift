//
//  StartupLoadingView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 15.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class StartupLoadingView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = appLaunchImage()
    }
    
    func appLaunchImage() -> UIImage? {
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        for imageName in allPngImageNames {
            guard imageName.contains("LaunchImage") else { continue }
            guard let image = UIImage(named: imageName) else { continue }
            
            if (image.scale == UIScreen.main.scale) && (image.size.equalTo(UIScreen.main.bounds.size)) {
                return image
            }
        }
        return nil
    }
}
