//
//  UIFont+Additions.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 7.10.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func applicationBoldFont(withSize size: CGFloat = 25) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    class func applicationLightFont(withSize size: CGFloat = 14) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .light)
    }
    
    class func applicationRegularFont(withSize size: CGFloat = 20) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
}
