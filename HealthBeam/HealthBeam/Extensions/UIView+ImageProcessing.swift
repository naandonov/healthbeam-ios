//
//  UIView+ImageProcessing.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 28.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

extension UIView {

    func snapshot(afterScreenUpdates: Bool = false) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates)
        }
        return image
    }

}
