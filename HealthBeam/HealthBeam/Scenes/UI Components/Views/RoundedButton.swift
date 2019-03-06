//
//  BorderedButton.swift
//  Sesame
//
//  Created by Nikolay Andonov on 22.10.18.
//  Copyright © 2018 sesame. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    @IBInspectable
    var prominentStyle = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    var startColor: UIColor {
        return .darkBlue
    }
    
    var middleColor: UIColor {
        return .neutralBlue
    }
    
    var endColor: UIColor {
        return .lightBlue
    }

    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = .zero
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
        return gradientLayer
    }()
    
    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
//        shapeLayer.path = UIBezierPath(rect: self.bounds).CGPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        return shapeLayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = bounds.height/2
        gradientLayer.frame = bounds
        shapeLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 2, dy: 2), cornerRadius: bounds.height/2).cgPath
//        shapeLayer.cornerRadius = bounds.height/2
        
        if prominentStyle {
            gradientLayer.mask = nil
            setTitleColor(.white, for: .normal)
        } else {
            gradientLayer.mask = shapeLayer
            setTitleColor(middleColor, for: .normal)
        }
    }
    
    //MARK:- Utilities
    
    private func setupUI() {
       
    
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
