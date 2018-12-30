//
//  BorderedButton.swift
//  Sesame
//
//  Created by Nikolay Andonov on 22.10.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = bounds.height/2
        gradientLayer.frame = bounds
    }
    
    //MARK:- Utilities
    
    private func setupUI() {
       
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.darkBlue.cgColor, UIColor.lightBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        layer.insertSublayer(gradientLayer, at: 0)
        
        setTitleColor(.white, for: .normal)
    }
}
