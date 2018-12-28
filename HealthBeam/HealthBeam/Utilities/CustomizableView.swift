//
//  RoundedView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.10.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import UIKit

private typealias BoundsInvalidationBlock = (UIRectCorner) -> (UIBezierPath)

class CustomizableView: UIView {
    
    @IBInspectable
    var topLeft: Bool = false
    
    @IBInspectable
    var topRight: Bool = false
    
    @IBInspectable
    var bottomLeft: Bool = false
    
    @IBInspectable
    var bottomRight: Bool = false
    
    var corners: UIRectCorner = []
    private var boundsInvalidationBlock: BoundsInvalidationBlock {
        return { [weak self] corners in
            return UIBezierPath(roundedRect: self?.bounds ?? .zero,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: self?.roundingRadius ?? 0, height: self?.roundingRadius ?? 0))
        }
    }
    
    private var roundingRadius: CGFloat = 0
    private let internalLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //The setter will assign the proper view bounds after an update
        let path = boundsInvalidationBlock(corners)
        internalLayer.frame = bounds
        internalLayer.path = path.cgPath
        
        gradientLayer.frame = bounds
        if let gradientMask = gradientLayer.mask as? CAShapeLayer {
            gradientMask.frame = bounds
            gradientMask.path = path.cgPath
        }
    }
    
    func setGradientBackground(colors: UIColor...){
        var cgColors: [CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        gradientLayer.colors = cgColors
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0.15)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 0.85)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 0.65), NSNumber(floatLiteral: 1.0)]
        
        let gradientMask = CAShapeLayer()
        gradientLayer.mask = gradientMask
        internalLayer.addSublayer(gradientLayer)
    }
    
}

//MARK: - Interface builder customizations

extension CustomizableView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return roundingRadius
        }
        set {
            corners = []
            roundingRadius =  newValue
            if topLeft {
                corners = [corners, .topLeft]
            }
            if topRight {
                corners = [corners, .topRight]
            }
            if bottomLeft {
                corners = [corners, .bottomLeft]
            }
            if bottomRight {
                corners = [corners, .bottomRight]
            }
            
            layer.backgroundColor = UIColor.clear.cgColor
            layer.insertSublayer(internalLayer, at: 0)
        }
    }
    
    @IBInspectable
    var internalColor: UIColor? {
        get {
            if let color = internalLayer.fillColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                internalLayer.fillColor = color.cgColor
            } else {
                internalLayer.fillColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
