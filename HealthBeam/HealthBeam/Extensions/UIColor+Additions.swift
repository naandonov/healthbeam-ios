//
//  UIColor+Additions.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.10.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var darkBlue: UIColor {
        return UIColor(hexString: "#4487b1")
    }
    
    class var neutralBlue: UIColor {
        return UIColor(hexString: "#65aad2")
    }
    
    class var lightBlue: UIColor {
        return UIColor(hexString: "#86cdf2")
    }
    
    class var paleGray: UIColor {
        return UIColor(hexString: "#f7f7f7")
    }
    
    class var darkRed: UIColor {
        return UIColor(hexString: "#9F041B")
    }
    
    class var neutralRed: UIColor {
        return UIColor(hexString: "#C8293C")
    }
    
    class var lightRed: UIColor {
        return UIColor(hexString: "#F5515F")
    }
    
    class var shadowColor: UIColor {
        return UIColor(hexString: "#979797")
    }
    
    class var subtleGray: UIColor {
        return UIColor(hexString: "#E8E8E8")
    }
    
    class func applicationGradientColorFoBounds(_ bounds: CGRect) -> UIColor {
        let backgroundImage = CAGradientLayer(applicationStyleWithFrame: bounds).gradientImage()
        return UIColor(patternImage: backgroundImage!)
    }
    
    class func applicationAlertColorFoBounds(_ bounds: CGRect) -> UIColor {
        let backgroundImage = CAGradientLayer(applicationAlertStyleWithFrame: bounds).gradientImage()
        return UIColor(patternImage: backgroundImage!)
    }
    
    //MARK: - Utilities
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
