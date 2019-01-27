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
        let gradientLayer = CAGradientLayer(applicationStyleWithFrame: bounds)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
