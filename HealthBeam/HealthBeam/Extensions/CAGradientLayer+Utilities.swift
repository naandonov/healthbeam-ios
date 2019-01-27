//
//  CAGradientLayer+Utilities.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 26.01.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    convenience init(applicationStyleWithFrame frame: CGRect) {
        self.init(linearWithFrame: frame, colors: [UIColor.darkBlue, UIColor.lightBlue])
    }
    
    convenience init(linearWithFrame frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = colors.map() { $0.cgColor }
        startPoint = CGPoint(x: 0.0, y: 0.5)
        endPoint = CGPoint(x: 1.0, y: 0.5)
        locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
    }
    
    func gradientImage() -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
