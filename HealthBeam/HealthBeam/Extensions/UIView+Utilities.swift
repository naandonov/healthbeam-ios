//
//  UIView+Utilities.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 31.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit

extension UIView {
    
    func firstResponder() -> UIView? {
        guard
            !isFirstResponder else { return self }
        guard
            !subviews.isEmpty else { return nil }
        
        if let responder = subviews.first(where: { $0.isFirstResponder }) {
            return responder
        }
        for subview in subviews {
            if let responder = subview.firstResponder() {
                return responder
            }
        }
        return nil
    }
    
    func setApplicationGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.darkBlue.cgColor, UIColor.lightBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
