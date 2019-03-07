//
//  OutlineView.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 3.02.19.
//  Copyright © 2019 nikolay.andonov. All rights reserved.
//

import UIKit

class OutlineView: UIView {
    
    @IBInspectable
    var top: Bool = false
    
    @IBInspectable
    var left: Bool = false
    
    @IBInspectable
    var bottom: Bool = false
    
    @IBInspectable
    var right: Bool = false
    
    @IBInspectable
    var strokeColor: UIColor = .lightGray
    
    var manuallyProvidedOutlineSides: OutlineSides?
    var outlinSides: OutlineSides {
        if let manuallyProvidedOutlineSides = manuallyProvidedOutlineSides {
            return manuallyProvidedOutlineSides
        }
        var outlineSides: OutlineSides = []
        if top {
            outlineSides = outlineSides.union(.top)
        }
        if left {
            outlineSides = outlineSides.union(.left)
        }
        if bottom {
            outlineSides = outlineSides.union(.bottom)
        }
        if right {
            outlineSides = outlineSides.union(.right)
        }
        
        return outlineSides
    }
    
    struct OutlineSides: OptionSet {
         let rawValue: Int
        
        static let top = OutlineSides(rawValue: 1 << 0)
        static let left = OutlineSides(rawValue: 1 << 1)
        static let bottom = OutlineSides(rawValue: 1 << 2)
        static let right = OutlineSides(rawValue: 1 << 3)
        static let all = [top, left, bottom, right]
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        if outlinSides.contains(.top) {
            let startPoint = CGPoint(x: bounds.minX, y: bounds.minY)
            let endPoint = CGPoint(x: bounds.maxX, y: bounds.minY)
            drawLineFrom(startPoint, to: endPoint, in: context)
        }
        if outlinSides.contains(.left) {
            let startPoint = CGPoint(x: bounds.minX, y: bounds.minY)
            let endPoint = CGPoint(x: bounds.minX, y: bounds.maxY)
            drawLineFrom(startPoint, to: endPoint, in: context)
        }
        if outlinSides.contains(.bottom) {
            let startPoint = CGPoint(x: bounds.minX, y: bounds.maxY)
            let endPoint = CGPoint(x: bounds.maxX, y: bounds.maxY)
            drawLineFrom(startPoint, to: endPoint, in: context)
        }
        if outlinSides.contains(.right) {
            let startPoint = CGPoint(x: bounds.maxX, y: bounds.minY)
            let endPoint = CGPoint(x: bounds.maxX, y: bounds.maxY)
            drawLineFrom(startPoint, to: endPoint, in: context)
        }
    }
    
    private func drawLineFrom(_ startPoint: CGPoint, to endPoint: CGPoint, in context: CGContext) {
        context.setLineWidth(1.0)
        context.setStrokeColor(strokeColor.cgColor)
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.strokePath()
    }

}
